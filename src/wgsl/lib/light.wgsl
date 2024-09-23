fn sample_light(r: vec4f) -> LightSample {
    let point = uniform_sample_sphere(r[0], r[1]) * sphere.radius[LIGHT_SPHERE_ID];
    let center = get_sphere_center(LIGHT_SPHERE_ID);
    let normal = point - center;
    let direction = cosine_sample_hemisphere(normal, r[2], r[3]);
}

fn get_sphere_center(id: u32) -> vec3f {
    return vec3f(sphere.center[0][id], sphere.center[1][id], sphere.center[2][id]);
}

fn get_sphere_color(id: u32) -> vec3f {
    return vec3f(sphere.color[0][id], sphere.color[1][id], sphere.color[2][id]);
}