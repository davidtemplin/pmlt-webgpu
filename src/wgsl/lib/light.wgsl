fn sample_light(r: vec4f) -> LightSample {
    let center = get_sphere_center(LIGHT_SPHERE_ID);
    let point = center + uniform_sample_sphere(r[0], r[1]) * sphere.radius[LIGHT_SPHERE_ID];
    let normal = normalize(point - center);
    let direction = cosine_sample_hemisphere(normal, r[2], r[3]);
    let positional_pdf = 1.0 / get_sphere_area(LIGHT_SPHERE_ID);
    let directional_pdf = abs(dot(normalize(direction), normal)) / PI;
    return LightSample(point, direction, normal, positional_pdf, directional_pdf);
}

fn light_positional_pdf(radius: f32) -> f32 {
    return 1.0 / (4.0 * PI * radius * radius);
}

fn light_directional_pdf(d: vec3f, n: vec3f) -> f32 {
    return abs_cos_theta(d, n) / PI;
}

fn light_direction_valid(direction: vec3f, normal: vec3f) -> bool {
    return dot(normal, direction) > 0.0;
}