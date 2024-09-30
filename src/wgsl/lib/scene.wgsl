fn intersect_sphere(center: vec3f, radius: f32, ray: Ray) -> f32 {
    let c = center - ray.origin;
    let b = dot(c, ray.direction);
    var det = b * b - dot(c, c) + radius * radius;
    if det < 0.0 {
        return MAX_F32;
    }
    det = sqrt(det);
    let threshold = 1e-4;
    var t = b - det;
    if t <= threshold {
        t = b + det;
        if t <= threshold {
            return MAX_F32;
        }
    }
    return t;
}

fn intersect(ray: Ray) -> Intersection {
    var best_t: f32 = MAX_F32;
    var best_sphere_id: u32 = 0;

    for (var i: u32 = 0; i < SPHERE_COUNT; i++) {
        let center = get_sphere_center(i);
        let radius = sphere.radius[i];
        let t = intersect_sphere(center, radius, ray);
        best_sphere_id = choose_u32(t < best_t, i, best_sphere_id);
        best_t = min(t, best_t);
    }

    let point = ray.origin + ray.direction * best_t;
    let center = get_sphere_center(best_sphere_id);
    let normal = normalize(point - center);

    return Intersection(point, normal, best_sphere_id, best_t < MAX_F32);
}

fn get_sphere_center(id: u32) -> vec3f {
    return vec3f(sphere.center[0][id], sphere.center[1][id], sphere.center[2][id]);
}

fn get_sphere_color(id: u32) -> vec3f {
    return vec3f(sphere.color[0][id], sphere.color[1][id], sphere.color[2][id]);
}

fn get_sphere_area(id: u32) -> f32 {
    let r = sphere.radius[id];
    return 4.0 * PI * r * r;
}