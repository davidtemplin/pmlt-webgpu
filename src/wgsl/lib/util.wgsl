fn erf_inv(x: f32) -> f32 {
    let xc = clamp(x, -0.99999, 0.99999);
    var w = log((1.0 - xc) * (1.0 + xc));
    if w < 5.0 {
        w = w - 2.5;
        var p = 2.81022636e-08;
        p = 3.43273939e-07 + p * w;
        p = -3.5233877e-06 + p * w;
        p = -4.39150654e-06 + p * w;
        p = 0.00021858087 + p * w;
        p = -0.00125372503 + p * w;
        p = -0.00417768164 + p * w;
        p = 0.246640727 + p * w;
        p = 1.50140941 + p * w;
        return p * x;
    } else {
        w = sqrt(w) - 3.0;
        var p = -0.000200214257;
        p = 0.000100950558 + p * w;
        p = 0.00134934322 + p * w;
        p = -0.00367342844 + p * w;
        p = 0.00573950773 + p * w;
        p = -0.0076224613 + p * w;
        p = 0.00943887047 + p * w;
        p = 1.00167406 + p * w;
        p = 2.83297682 + p * w;
        return p * x;
    }
}

fn sample_technique(path_length: u32, r: f32) -> Technique {
    let camera = 1 + u32(r * f32(path_length)); // pinhole camera; at least one camera vertex
    let light = path_length - camera;
    return Technique(camera, light);
}

fn uniform_sample_sphere(u1: f32, u2: f32) -> vec3f {
    let z = 1.0 - 2.0 * u1;
    let r = sqrt(max(0.0, 1.0 - z * z));
    let phi = 2.0 * PI * u2;
    return vec3f(r * cos(phi), r * sin(phi), z);
}

fn cosine_sample_hemisphere(n: vec3f, u1: f32, u2: f32) -> vec3f {
    // Sample a unit disk in R^2
    let xy = concentric_sample_disk(u1, u2);

    // Compute an orthonormal basis relative to n as the "z" direction
    let b = orthonormal_basis(n);

    // Compute the coordinates in this new orthonormal basis relative to the normal vector nz
    let z = sqrt(max(0.0, 1.0 - xy.x * xy.x - xy.y * xy.y));

    // Done
    return b.u * xy.x + b.v * xy.y + b.w * z;
}

fn concentric_sample_disk(u1: f32, u2: f32) -> vec2f {
    // Map uniform random numbers to $[-1,1]^2$
    let u_offset_x = 2.0 * u1 - 1.0;
    let u_offset_y = 2.0 * u2 - 1.0;

    // Handle degeneracy at the origin
    if u_offset_x == 0.0 && u_offset_y == 0.0 {
        return vec2f(0.0, 0.0);
    }

    // Apply concentric mapping to point
    var r: f32;
    var theta: f32;
    if abs(u_offset_x) > abs(u_offset_y) {
        r = u_offset_x;
        theta = (PI / 4.0) * (u_offset_y / u_offset_x);
    } else {
        r = u_offset_y;
        theta = (PI / 2.0) - ((PI / 4.0) * (u_offset_x / u_offset_y));
    }

    // Done
    return vec2f(r * cos(theta), r * sin(theta));
}

fn is_zero(v: vec3f) -> bool {
    return v.x == 0.0 && v.y == 0.0 && v.z == 0.0;
}

fn orthonormal_basis(n: vec3f) -> Basis {
    let nz = normalize(n);
    let ey = vec3f(0.0, 1.0, 0.0);
    var nx = normalize(cross(ey, nz));
    var ny: vec3f;
    if is_zero(nx) {
        let ex = vec3f(1.0, 0.0, 0.0);
        ny = normalize(cross(nz, ex));
        nx = normalize(cross(ny, nz));
    } else {
        ny = normalize(cross(nz, nx));
    };
    return Basis(nx, ny, nz);
}

fn choose_u32(b: bool, u1: u32, u2: u32) -> u32 {
    return u32(b) * u1 + u32(!b) * u2;
}

fn choose_f32(b: bool, u1: f32, u2: f32) -> f32 {
    return f32(b) * u1 + f32(!b) * u2;
}

fn choose_vec3f(b: bool, v1: vec3f, v2: vec3f) -> vec3f {
    return f32(b) * v1 + f32(!b) * v2;
}

fn approx_eq_f32(a: f32, b: f32, tolerance: f32) -> bool {
    return abs(a - b) < tolerance;
}

fn approx_eq_vec3f(a: vec3f, b: vec3f, tolerance: f32) -> bool {
    return approx_eq_f32(a.x, b.x, tolerance) && approx_eq_f32(a.y, b.y, tolerance) && approx_eq_f32(a.z, b.z, tolerance);
}

fn same_hemisphere(n: vec3f, v1: vec3f, v2: vec3f) -> bool {
    return sign(dot(v1, n)) == sign(dot(v2, n));
}

fn abs_cos_theta(n: vec3f, v: vec3f) -> f32 {
    return abs(dot(normalize(n), normalize(v)));
}

fn geometry_term(direction: vec3f, normal1: vec3f, normal2: vec3f) -> f32 {
    let d2 = dot(direction, direction);
    let x = (dot(normal1, direction) * dot(normal2, direction)) / (d2 * d2);
    return abs(x);
}

fn direction_to_area(direction: vec3f, normal: vec3f) -> f32 {
    let d2 = dot(direction, direction);
    let x = dot(normal, direction) / (d2 * sqrt(d2));
    return abs(x);
}

fn luminance(v: vec3f) -> f32 {
    return v.r * 0.212671 + v.g * 0.715160 + v.b * 0.072169;
}