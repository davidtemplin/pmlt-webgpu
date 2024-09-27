fn sample_light(r: vec4f) -> LightSample {
    let point = uniform_sample_sphere(r[0], r[1]) * sphere.radius[LIGHT_SPHERE_ID];
    let center = get_sphere_center(LIGHT_SPHERE_ID);
    let normal = point - center;
    let direction = cosine_sample_hemisphere(normal, r[2], r[3]);
    let positional_pdf = 1.0 / get_sphere_area(LIGHT_SPHERE_ID);
    let directional_pdf = abs(dot(normalize(direction), normal)) / PI;
    return LightSample(point, direction, normal, positional_pdf, directional_pdf);
}