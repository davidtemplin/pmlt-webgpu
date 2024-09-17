fn contribute(contribution: vec3f, x: u32, y: u32) {
    let scale = 1024.0 * 1024.0 * 1024.0;
    let r = u32(contribution.x * scale);
    let g = u32(contribution.y * scale);
    let b = u32(contribution.z * scale);
    let i = y * PIXEL_WIDTH + x;
    atomicAdd(&image.r[i], r);
    atomicAdd(&image.g[i], g);
    atomicAdd(&image.b[i], b);
}

fn read_image(x: u32, y: u32) -> vec3f {
    let scale = 1024.0 * 1024.0 * 1024.0;
    let i = y * PIXEL_WIDTH + x;
    let r = f32(atomicLoad(&image.r[i])) / scale;
    let g = f32(atomicLoad(&image.r[i])) / scale;
    let b = f32(atomicLoad(&image.r[i])) / scale;
    // TODO: tone-map, gamma-correct
    return vec3f(r, g, b);
}