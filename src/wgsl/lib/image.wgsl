fn contribute(contribution: vec3f, x: u32, y: u32) {
    if image.write_mode == ENABLED {
        let c = clamp_contribution(contribution);
        atomicAdd(&image.pixels[0][x][y], u32(c.r * FIXED_POINT_SCALE));
        atomicAdd(&image.pixels[1][x][y], u32(c.g * FIXED_POINT_SCALE));
        atomicAdd(&image.pixels[2][x][y], u32(c.b * FIXED_POINT_SCALE));
    }
}

fn read_image(x: u32, y: u32) -> vec4f {
    let r = atomicLoad(&image.pixels[0][x][y]);
    let g = atomicLoad(&image.pixels[1][x][y]);
    let b = atomicLoad(&image.pixels[2][x][y]);
    return vec4f(f32(r) / FIXED_POINT_SCALE, f32(g) / FIXED_POINT_SCALE, f32(b) / FIXED_POINT_SCALE, 1.0);
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