fn get_pixel_coordinates(ray: Ray) -> PixelCoordinates {
    let d = normalize(ray.origin - camera.origin);
    let screen_center = camera.w * camera.distance;
    let wd = dot(camera.w, d);
    if wd == 0.0 {
        return PixelCoordinates(0, 0, false);
    }
    let t = dot(camera.w, screen_center) / wd;
    if t <= 0.0 {
        return PixelCoordinates(0, 0, false);
    }
    let p = t * d - screen_center;
    let px = u32(dot(camera.u, p) + f32(PIXEL_WIDTH) * 0.5);
    let py = u32(-dot(camera.v, p) + f32(PIXEL_HEIGHT) * 0.5);
    if 0 <= px && px < PIXEL_WIDTH && 0 <= py && py < PIXEL_HEIGHT {
        return PixelCoordinates(px, py, true);
    }
    return PixelCoordinates(0, 0, false);
}

fn camera_importance(direction: vec3f) -> f32 {
    let c = dot(normalize(direction), camera.w);
    let a = f32(PIXEL_WIDTH) * f32(PIXEL_HEIGHT);
    let c4 = c * c * c * c;
    let d2 = camera.distance * camera.distance;
    return d2 / (a * c4);
}

fn camera_directional_pdf(direction: vec3f) -> f32 {
    let c = dot(normalize(direction), camera.w);
    let d = camera.distance / c;
    let d2 = d * d;
    let a = f32(PIXEL_WIDTH) * f32(PIXEL_HEIGHT);
    return d2 / (a * c);
}