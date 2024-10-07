@compute
@workgroup_size(WORKGROUP_SIZE)
fn sample_material_main(@builtin(global_invocation_id) id: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index = id.x;
    let i = queue.index[SAMPLE_MATERIAL_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if global_invocation_index < atomicLoad(&queue.count[SAMPLE_MATERIAL_QUEUE_ID]) {
        // Context
        let vertex_index = path.vertex_index[i];
        let technique = get_technique(i);
        let stream_index = choose_u32(vertex_index < technique.camera, CAMERA_STREAM_INDEX, LIGHT_STREAM_INDEX);
        let path_type = choose_u32(vertex_index < technique.camera, CAMERA, LIGHT);

        // Sample
        let normal = get_normal(path_type, ULTIMATE, i);
        let p1 = get_point(path_type, PENULTIMATE, i);
        let p2 = get_point(path_type, ULTIMATE, i);
        let wo = p1 - p2;
        let sample = sample_material(path.material_id[path_type][i], p2, wo, normal, rand_2(i, stream_index));

        // Update ray
        set_ray_origin(i, p2);
        set_ray_direction(i, sample.wi);

        // MIS
        let ri = sample.pdf_rev / path.pdf_fwd[path_type][PENULTIMATE][i];
        path.prod_ri[path_type][i] *= ri;
        path.sum_inv_ri[path_type][i] += 1.0 / path.prod_ri[path_type][i];

        // PDF
        path.directional_pdf[i] = sample.pdf_fwd;

        // Beta
        let beta = sample.throughput;
        update_beta(i, beta);

        // Determine queue
        queue_id = choose_u32(sample.valid, INTERSECT_QUEUE_ID, queue_id);
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}