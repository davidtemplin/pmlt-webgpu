fn set_ray_origin(i: u32, o: vec3f) {
    path.ray_origin[0][i] = o.x;
    path.ray_origin[1][i] = o.y;
    path.ray_origin[2][i] = o.z;
}

fn set_ray_direction(i: u32, d: vec3f) {
    path.ray_direction[0][i] = d.x;
    path.ray_direction[1][i] = d.y;
    path.ray_direction[2][i] = d.z;
}

fn set_technique(i: u32, t: Technique) {
    path.technique[CAMERA][i] = t.camera;
    path.technique[LIGHT][i] = t.light;
}

fn set_point(a: u32, b: u32, i: u32, p: vec3f) {
    path.point[a][b][0][i] = p.x;
    path.point[a][b][1][i] = p.y;
    path.point[a][b][2][i] = p.z;
}

fn get_point(t: u32, o: u32, i: u32) -> vec3f {
    return vec3f(path.point[t][o][0][i], path.point[t][o][1][i], path.point[t][o][2][i]);
}

fn get_normal(t: u32, o: u32, i: u32) -> vec3f {
    return vec3f(path.normal[t][o][0][i], path.normal[t][o][1][i], path.normal[t][o][2][i]);
}

fn set_normal(a: u32, b: u32, i: u32, p: vec3f) {
    path.normal[a][b][0][i] = p.x;
    path.normal[a][b][1][i] = p.y;
    path.normal[a][b][2][i] = p.z;
}

fn shift_point(path_type: u32, i: u32) {
    set_point(path_type, PENULTIMATE, i, get_point(path_type, ULTIMATE, i));
}

fn shift_normal(path_type: u32, i: u32) {
    set_normal(path_type, PENULTIMATE, i, get_normal(path_type, ULTIMATE, i));
}

fn get_ray_origin(i: u32) -> vec3f {
    return vec3f(path.ray_origin[0][i], path.ray_origin[1][i], path.ray_origin[2][i]);
}

fn get_ray_direction(i: u32) -> vec3f {
    return vec3f(path.ray_direction[0][i], path.ray_direction[1][i], path.ray_direction[2][i]);
}

fn get_ray(i: u32) -> Ray {
    return Ray(get_ray_origin(i), get_ray_direction(i));
}

fn get_technique(i: u32) -> Technique {
    return Technique(path.technique[CAMERA][i], path.technique[LIGHT][i]);
}

fn shift_pdf_fwd(path_type: u32, i: u32) {
    path.pdf_fwd[path_type][PENULTIMATE][i] = path.pdf_fwd[path_type][ULTIMATE][i];
}

fn update_beta(i: u32, beta: vec3f) {
    path.beta[0][i] *= beta.r;
    path.beta[1][i] *= beta.g;
    path.beta[2][i] *= beta.b;
}

fn set_beta(i: u32, beta: vec3f) {
    path.beta[0][i] = beta.r;
    path.beta[1][i] = beta.g;
    path.beta[2][i] = beta.b;
}

fn get_beta(i: u32) -> vec3f {
    return vec3f(path.beta[0][i], path.beta[1][i], path.beta[2][i]);
}

fn get_mis_weight(i: u32) -> f32 {
    let sum_ri = path.sum_inv_ri[CAMERA][i] * path.prod_ri[CAMERA][i] + path.prod_ri[CAMERA][i] - 1.0 
        + path.sum_inv_ri[LIGHT][i] * path.prod_ri[LIGHT][i] + path.prod_ri[LIGHT][i] - 1.0;
    return 1.0 / (1.0 + sum_ri);
}

fn get_path_contribution(i: u32) -> vec3f {
    return get_beta(i) * get_mis_weight(i);
}

fn binary_search(min_path_index: u32, max_path_index: u32, sum: f32, goal: f32) -> u32 {
    var l: u32 = min_path_index;
    var r: u32 = max_path_index;
    var m: u32 = 0;

    while l <= r {
        m = (l + r) / 2;
        if m == min_path_index {
            break;
        }
        let vr = path.cdf[PRIMARY][m] / sum;
        if goal <= vr {
            let vl = path.cdf[PRIMARY][m - 1] / sum;
            if goal > vl {
                break;
            } else {
                r = m - 1;
            }
        } else {
            l = m + 1;
        }
    }

    return m;
}

fn set_pixel(i: u32, x: u32, y: u32) {
    path.pixel[0][i] = x;
    path.pixel[1][i] = y;
}

fn get_pixel(i: u32) -> vec2u {
    return vec2u(path.pixel[0][i], path.pixel[1][i]);
}