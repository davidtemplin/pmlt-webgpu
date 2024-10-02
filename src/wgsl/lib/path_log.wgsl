fn log_vertex(path_type: u32, i: u32) {
    if PATH_LOG_ENABLED {
        if i == PATH_LOG_TARGET_INDEX {
            let point = get_point(path_type, ULTIMATE, i);
            let normal = get_normal(path_type, ULTIMATE, i);
            let direction = get_ray_direction(i);
            let sphere_id = path.material_id[path_type][i];
            let vertex_index = path.vertex_index[i];
            let technique = get_technique(i);
            var j: u32 = 0;
            if vertex_index < technique.camera {
                j = vertex_index;
            } else {
                j = (technique.camera + technique.light) - (vertex_index - technique.camera) - 1;
            }
            path_log.vertices[j] = VertexLog(point, normal, direction, sphere_id);
        }
    }
}

fn log_contribution(i: u32) {
    if PATH_LOG_ENABLED {
        if i == PATH_LOG_TARGET_INDEX {
            path_log.beta = get_beta(i);
            path_log.mis_weight = get_mis_weight(i);
        }
    }
}