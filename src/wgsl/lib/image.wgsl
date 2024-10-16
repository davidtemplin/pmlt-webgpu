fn contribute(contribution: vec3f, x: u32, y: u32) {
    atomicAdd(&image.pixels[y][x][0], u32(contribution.r * FIXED_POINT_SCALE));
    atomicAdd(&image.pixels[y][x][1], u32(contribution.g * FIXED_POINT_SCALE));
    atomicAdd(&image.pixels[y][x][2], u32(contribution.b * FIXED_POINT_SCALE));
}

fn read_image(x: u32, y: u32) -> vec4f {
    let r = atomicLoad(&image.pixels[y][x][0]);
    let g = atomicLoad(&image.pixels[y][x][1]);
    let b = atomicLoad(&image.pixels[y][x][2]);
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