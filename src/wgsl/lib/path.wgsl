fn set_ray_origin(i: u32, o: vec3f) {
    path.ray_origin_x[i] = o.x;
    path.ray_origin_y[i] = o.y;
    path.ray_origin_z[i] = o.z;
}

fn set_ray_direction(i: u32, d: vec3f) {
    path.ray_direction_x[i] = d.x;
    path.ray_direction_y[i] = d.y;
    path.ray_direction_z[i] = d.z;
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