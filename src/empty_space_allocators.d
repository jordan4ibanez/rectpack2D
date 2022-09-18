module empty_space_allocators;

/*
#pragma once
#include <array>
#include <vector>
#include <type_traits>

#include "rect_structs.h"
*/
import rect_structs;
import std.range.primitives: popBack, back;
import std.container.array.array: clear;

public class default_empty_spaces {
    
	space_rect[] empty_spaces;

	public:
		void remove(const int i) {
			empty_spaces[i] = empty_spaces.back();
			empty_spaces.popBack();
		}

		bool add(const space_rect r) {
			empty_spaces ~= r;
			return true;
		}

		long get_count() const {
			return empty_spaces.length;
		}

		void reset() {
			empty_spaces.clear();
		}

		space_rect get(const int i) {
			return empty_spaces[i];
		}
}

class static_empty_spaces {

	int count_spaces = 0;

	space_rect[] empty_spaces;

    this(long maxSpaces) {
        this.empty_spaces = new space_rect[maxSpaces];
    }

	public:

		void remove(const int i) {
			empty_spaces[i] = empty_spaces[count_spaces - 1];
			--count_spaces;
		}

		bool add(const space_rect r) {
			if (count_spaces < static_cast<int>(empty_spaces.size())) {
				empty_spaces[count_spaces] = r;
				++count_spaces;

				return true;
			}

			return false;
		}
		
		auto get_count() const {
			return count_spaces;
		}

		void reset() {
			count_spaces = 0;
		}

		const auto& get(const int i) {
			return empty_spaces[i];
		}
};
