module rect_structs;

import std.algorithm.mutation: swap;

pragma(once);
// #include <utility>

    
	alias total_area_type = int;

	struct rect_wh {

		int w = 0;
		int h = 0;

		rect_wh flip() {
			swap(w, h);
			return this;
		}

		int max_side() const {
			return h > w ? h : w;
		}

		int min_side() const {
			return h < w ? h : w;
		}

		int	area() const { return w * h; }
	   	int perimeter() const { return 2 * w + 2 * h; }

		float pathological_mult() const {
			return float(max_side()) / min_side() * area();
		}

		template <class R>
		void expand_with(const R& r) {
			w = std::max(w, r.x + r.w);
			h = std::max(h, r.y + r.h);
		}
	};

	struct rect_xywh {
		int x = 0;
		int	y = 0;
		int w = 0;
		int h = 0;

		int	area() const { return w * h; }
		int perimeter() const { return 2 * w + 2 * h; }

		auto get_wh() const {
			return rect_wh(w, h);
		}
	};

	struct rect_xywhf {
		int x;
		int y;
		int w;
		int h;
		bool flipped;

		rect_xywhf() : x(0), y(0), w(0), h(0), flipped(false) {}
		rect_xywhf(const int x, const int y, const int w, const int h, const bool flipped) : x(x), y(y), w(flipped ? h : w), h(flipped ? w : h), flipped(flipped) {}
		rect_xywhf(const rect_xywh& b) : rect_xywhf(b.x, b.y, b.w, b.h, false) {}

		int	area() const { return w * h; }
		int perimeter() const { return 2 * w + 2 * h; }

		auto get_wh() const {
			return rect_wh(w, h);
		}
	};

	using space_rect = rect_xywh;
}