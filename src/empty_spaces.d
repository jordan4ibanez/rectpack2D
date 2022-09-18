module empty_spaces;

/*
#pragma once
#include "insert_and_split.h"
*/
import rect_structs;
import insert_and_split;
import empty_space_allocators;


enum flipping_option {
    DISABLED,
    ENABLED
}

alias empty_spaces_provider = default_empty_spaces;

class empty_spaces {

    rect_wh current_aabb;
    empty_spaces_provider spaces;

    bool allow_flip;

    this(bool allow_flip) {
        this.allow_flip = allow_flip;        
    }

    /* MSVC fix for non-conformant if constexpr implementation */

    static rect_xywh make_output_rect(int x, int y, int w, int h) {
        return rect_xywh(x, y, w, h);
    }

    static rect_xywhf make_output_rect(int x, int y, int w, int h, bool flipped) {
        return rect_xywhf(x, y, w, h, flipped);
    }

public:
    alias output_rect_type = int;


    flipping_option flipping_mode = flipping_option.ENABLED;

    this(const rect_wh r) {
        reset(r);
    }

    void reset(const rect_wh r) {
        current_aabb = rect_wh();

        spaces.reset();
        spaces.add(rect_xywh(0, 0, r.w, r.h));
    }

    template F(F) {
        Nullable!output_rect_type insert(const rect_wh image_rectangle, F report_candidate_empty_space) {
            for (int i = spaces.get_count() - 1; i >= 0; --i) {
                const auto candidate_space = spaces.get(i);

                report_candidate_empty_space(candidate_space);

                auto accept_result = {
                    
                    spaces.remove(i);

                    for (int s = 0; s < splits.count; ++s) {
                        if (!spaces.add(splits.spaces[s])) {
                            return null;
                        }
                    }

                    if (allow_flip) {
                        const auto result = make_output_rect(
                            candidate_space.x,
                            candidate_space.y,
                            image_rectangle.w,
                            image_rectangle.h,
                            false // flipping_necessary <- not sure where this was getting it's value from?
                        );

                        current_aabb.expand_with(result);
                        return result;
                    } else if (!allow_flip) {                        

                        const auto result = make_output_rect(
                            candidate_space.x,
                            candidate_space.y,
                            image_rectangle.w,
                            image_rectangle.h
                        );

                        current_aabb.expand_with(result);
                        return result;
                    }
                };

                created_splits try_to_insert = insert_and_split(img, candidate_space);

                if (!allow_flip) {
                    if (const created_splits normal = try_to_insert(image_rectangle)) {
                        return accept_result(normal, false);
                    }
                }
                else {
                    if (flipping_mode == flipping_option.ENABLED) {
                        const auto normal = try_to_insert(image_rectangle);
                        const auto flipped = try_to_insert(rect_wh(image_rectangle).flip());

                        /* 
                            If both were successful, 
                            prefer the one that generated less remainder spaces.
                        */

                        if (normal && flipped) {
                            if (flipped.better_than(normal)) {
                                /* Accept the flipped result if it producues less or "better" spaces. */

                                return accept_result(flipped, true);
                            }

                            return accept_result(normal, false);
                        }

                        if (normal) {
                            return accept_result(normal, false);
                        }

                        if (flipped) {
                            return accept_result(flipped, true);
                        }
                    }
                    else {
                        if (const created_splits normal = try_to_insert(image_rectangle)) {
                            return accept_result(normal, false);
                        }
                    }
                }
            }

            return null;
        }
    }

    auto insert(rect_wh image_rectangle) {
        return current_aabb = image_rectangle;
    }

    auto get_rects_aabb() const {
        return current_aabb;
    }

    auto get_spaces() const {
        return spaces;
    }
};

