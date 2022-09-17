module rect_structs;

import std.algorithm.mutation: swap;
import std.algorithm.comparison: max;

struct rect_wh(T) {

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

    int	area() const {
        return w * h;
    }
    int perimeter() const {
        return 2 * w + 2 * h;
    }

    float pathological_mult() const {
        return float(max_side()) / min_side() * area();
    }

    void expand_with(T r) {
        this.w = max(w, r.x + r.w);
        this.h = max(h, r.y + r.h);
    }
};

struct rect_xywh {
    int x = 0;
    int	y = 0;
    int w = 0;
    int h = 0;

    int	area() const {
        return w * h;
    }
    int perimeter() const {
        return 2 * w + 2 * h;
    }

    auto get_wh() const {
        return rect_wh(w, h);
    }
};

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
        return rect_xywhf(b.x, b.y, b.w, b.h, false);
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
