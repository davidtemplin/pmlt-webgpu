fn contribute(contribution: vec3f, x: u32, y: u32) {
    if image.write_mode == ENABLED {
        if !is_valid_contribution(contribution) {
            return;
        }
        let c = clamp_contribution(contribution);
        for (var i: u32 = 0; i < 3; i++) {
            var success = false;
            while (!success) {
                let u = atomicLoad(&image.pixels[i][x][y]);
                let v = bitcast<u32>(bitcast<f32>(u) + c[i]);
                success = atomicCompareExchangeWeak(&image.pixels[i][x][y], u, v).exchanged;
            }
        }
    }
}

fn read_image(x: u32, y: u32) -> vec4f {
    let r = atomicLoad(&image.pixels[0][x][y]);
    let g = atomicLoad(&image.pixels[1][x][y]);
    let b = atomicLoad(&image.pixels[2][x][y]);
    return vec4f(bitcast<f32>(r), bitcast<f32>(g), bitcast<f32>(b), 1.0);
}

fn tone_map(value: vec4f) -> vec4f {
    return vec4f(tone_map_f32(value.r), tone_map_f32(value.g), tone_map_f32(value.b), 1.0);
}

fn gamma_correct(value: vec4f) -> vec4f {
    return vec4f(gamma_correct_f32(value.r), gamma_correct_f32(value.g), gamma_correct_f32(value.b), 1.0);
}

fn tone_map_f32(value: f32) -> f32 {
    return 1.0 - exp(-value);
}

fn gamma_correct_f32(value: f32) -> f32 {
    return pow(value, 1.0 / 2.2);
}

fn clamp_contribution(c: vec3f) -> vec3f {
    let m = max(c.r, max(c.g, c.b));
    let scale = MAX_CONTRIBUTION / m;
    let x = select(1.0, scale, m > MAX_CONTRIBUTION);
    return c * x;
}

fn is_valid_number(n: f32) -> bool {
    return n == n && n >= MIN_F32 && n <= MAX_F32;
}

fn is_valid_contribution(c: vec3f) -> bool {
    return is_valid_number(c.r) && is_valid_number(c.g) && is_valid_number(c.b);
}