@compute
@workgroup_size(WORKGROUP_SIZE)
fn intersect_main(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index: u32 = id.x;
    let i = queues[INTERSECT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue_counts[INTERSECT_QUEUE_ID]) {
        // Intersect
        let ray = get_ray(i);
        let intersection = intersect(ray);

        // Context
        let path_length = path.length[i];
        let vertex_index = path.vertex_index[i];
        let technique = get_technique(i);
        let path_type = choose_u32(vertex_index < technique.camera, CAMERA, LIGHT);

        // MIS
        shift_pdf_fwd(path_type, i);
        let direction = intersection.point - path.point[path_type][ULTIMATE][i];
        path.pdf_fwd[path_type][ULTIMATE][i] = path.directional_pdf[path_type][i] * direction_to_area(direction, intersection.normal);

        // Beta
        let beta = vec3f(1.0, 1.0, 1.0) * abs_cos_theta(direction, intersection.normal);
        update_beta(i, beta);

        // Scalar contribution
        path.scalar_contribution[i] = choose_f32(intersection.valid, path.scalar_contribution[i], 0.0);

        // Material
        path.material_id[path_type][i] = intersection.material_id;

        // Geometry
        shift_point(path_type, i);
        shift_normal(path_type, i);
        set_point(path_type, ULTIMATE, i, intersection.point);
        set_normal(path_type, ULTIMATE, i, intersection.normal);

        // Determine queue
        queue_id = choose_u32(vertex_index + 1 < technique.camera || vertex_index + 1 < technique.light, SAMPLE_MATERIAL_QUEUE_ID, queue_id);
        queue_id = choose_u32(vertex_index == path_length - 1, CONNECT_QUEUE_ID, queue_id);
        queue_id = choose_u32(vertex_index == technique.camera - 1 && technique.light == 0, CONTRIBUTE_QUEUE_ID, queue_id);
        queue_id = choose_u32(vertex_index == technique.camera - 1, SAMPLE_LIGHT_QUEUE_ID, queue_id);
        queue_id = choose_u32(intersection.valid, queue_id, NULL_QUEUE_ID);
    }

    // Enqueue
    enqueue(global_invocation_index, lid, queue_id);
}