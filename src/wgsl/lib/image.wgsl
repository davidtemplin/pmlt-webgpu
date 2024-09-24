fn contribute(contribution: vec3f, x: u32, y: u32) {
    atomicAdd(&image.pixels[y][x][0], u32(contribution.r * FIXED_POINT_SCALE));
    atomicAdd(&image.pixels[y][x][1], u32(contribution.g * FIXED_POINT_SCALE));
    atomicAdd(&image.pixels[y][x][2], u32(contribution.b * FIXED_POINT_SCALE));
}

fn read_image(x: u32, y: u32) -> vec3f {
    let r = atomicLoad(&image.pixels[y][x][0]);
    let g = atomicLoad(&image.pixels[y][x][1]);
    let b = atomicLoad(&image.pixels[y][x][2]);
    return vec3f(f32(r) / FIXED_POINT_SCALE, f32(g) / FIXED_POINT_SCALE, f32(b) / FIXED_POINT_SCALE);
}