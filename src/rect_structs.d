module rect_structs;

import std.algorithm.mutation: swap;
import std.algorithm.comparison: max;

alias total_area_type = int;

struct rect_wh {

    int w = 0;
    int h = 0;

    this(const int w, const int h) {
        this.w = w;
        this.h = h;
    }

    rect_wh flip() {
        swap(this.w, this.h);
        return this;
    }

    int max_side() const {
        return h > w ? h : w;
    }

    int min_side() const {
        return h < w ? h : w;
    }

    int	area() const {
        return w * h;
    }
    int perimeter() const {
        return 2 * w + 2 * h;
    }

    float pathological_mult() const {
        return float(max_side()) / min_side() * area();
    }

    template t(T) {
        void expand_with(T r) {
            w = max(w, r.x + r.w);
            h = max(h, r.y + r.h);
        }
    }
}

struct rect_xywh {
    int x = 0;
    int	y = 0;
    int w = 0;
    int h = 0;

    this(int w, int h) const {
        this.w = w;
        this.h = h;
    }
    this(int x, int y, int w, int h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
    }

    int	area() const {
        return w * h;
    }
    int perimeter() const {
        return 2 * w + 2 * h;
    }

    auto get_wh() const {
        return rect_wh(w, h);
    }
}

struct rect_xywhf {

    int x = 0;
    int y = 0;
    int w = 0;
    int h = 0;
    bool flipped = false;

    this(int x, int y, int w, int h, bool flipped){
        this.x = x;
        this.y = y;
        this.w = flipped ? h : w;
        this.h = flipped ? w : h;
        this.flipped = flipped;
    } 

    this(rect_xywh b) {
        rect_xywhf(b.x, b.y, b.w, b.h, false);
    }

    int	area() const {
        return w * h;
    }
    int perimeter() const {
        return 2 * w + 2 * h;
    }
    auto get_wh() const {
        return rect_wh(w, h);
    }
}

alias space_rect = rect_xywh;