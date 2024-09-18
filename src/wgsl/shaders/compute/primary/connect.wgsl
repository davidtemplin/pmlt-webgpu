@compute
@workgroup_size(WORKGROUP_SIZE)
fn connect(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid) {
    let global_invocation_index = id.x;
    let queue_id: u32 = NULL_QUEUE_ID;
    if global_invocation_index < atomicLoad(&queue_counts[CONNECT_QUEUE_ID]) {
        let global_path_index = queues[CONNECT_QUEUE_ID][global_invocation_index];
        let source_point = vec3f(path_state.final_camera_point_x[global_path_index], path_state.final_camera_point_y[global_path_index], path_state.final_camera_point_z[global_path_index]);
        let destination_point = vec3f(path_state.previous_point_x[global_path_index], path_state.previous_point_y[global_path_index], path_state.previous_point_z[global_path_index]);
        let direction = normalize(destination_point - source_point);
        let ray = Ray(source_point, direction);
        let intersection = intersect(ray);
        let pixel_coordinates = get_pixel_coordinates(ray);
        let valid = (pixel_coordinates.valid || path_length != 2) && intersection.valid && approx_eq_vec3f(intersection.point, destination_point);
        queue_id = choose_u32(valid, CONTRIBUTE_QUEUE_ID, queue_id);

        let normal1 = vec3f(path_state.final_camera_normal_x[global_path_index], path_state.final_camera_normal_y[global_path_index], path_state.final_camera_normal_z[global_path_index]);
        let normal2 = vec3f(path_state.previous_normal_x[global_path_index], path_state.previous_normal_y[global_path_index], path_state.previous_normal_z[global_path_index]);
        let wo = vec3f(path_state.final_camera_wo_x[global_path_index], path_state.final_camera_wo_y[global_path_index], path_state.final_camera_wo_z[global_path_index])
        let importance = camera_importance(direction);
        let shape_id = path_state.final_camera_shape_id[global_path_index];
        let color = vec3f(shape.color_r[shape_id], shape.color_g[shape_id], shape.color_b[shape_id]);
        let wi = direction;
        let reflectance = matte_material_reflectance(wo, normal1, wi);
        let g = geometry_term(direction, normal1, normal2);
        let throughput = choose_f32(path_length == 2, importance, reflectance) * g * color;
        let area_pdf = matte_material_directional_pdf(wo, normal1, wi) * direction_to_area(wi, normal2);
        let c = throughput / area_pdf;
        path_state.contribution_r[global_path_index] *= c.r;
        path_state.contribution_g[global_path_index] *= c.g;
        path_state.contribution_b[global_path_index] *= c.b;
    }
    enqueue(global_invocation_id, lid, queue_id);
}