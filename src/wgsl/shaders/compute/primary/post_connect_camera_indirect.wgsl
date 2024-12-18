@compute
@workgroup_size(WORKGROUP_SIZE)
fn post_connect_camera_indirect_main(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[POST_CONNECT_CAMERA_INDIRECT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if global_invocation_index < atomicLoad(&queue.count[POST_CONNECT_CAMERA_INDIRECT_QUEUE_ID]) {
        // Context
        let material_id = path.material_id[CAMERA][i];
        let technique = get_technique(i);

        // Compute geometry
        let p1 = get_point(CAMERA, PENULTIMATE, i);
        let p2 = get_point(CAMERA, ULTIMATE, i);
        let p3 = get_point(LIGHT, ULTIMATE, i);
        let n1 = get_normal(CAMERA, PENULTIMATE, i);
        let n2 = get_normal(CAMERA, ULTIMATE, i);
        let n3 = get_normal(LIGHT, ULTIMATE, i);
        let wo = p1 - p2;
        let wi = p3 - p2;

        // Evaluate material
        let evaluation = evaluate_material(material_id, wo, n2, wi);

        // Beta
        let g = choose_f32(technique.light > 1, geometry_term(wi, n2, n3), 1.0);
        let beta = evaluation.throughput * g;
        update_beta(i, beta);

        // MIS
        let ri1 = evaluation.pdf_rev * direction_to_area(wo, n1) / path.pdf_fwd[CAMERA][PENULTIMATE][i];
        path.prod_ri[CAMERA][i] *= ri1;
        path.sum_inv_ri[CAMERA][i] += 1.0 / path.prod_ri[CAMERA][i];

        let ri2 = evaluation.pdf_fwd * direction_to_area(wi, n3) / path.pdf_fwd[LIGHT][ULTIMATE][i];
        path.final_ri[i] = ri2;

        // Choose next queue
        queue_id = choose_u32(technique.light > 1, POST_CONNECT_LIGHT_INDIRECT_QUEUE_ID, POST_CONNECT_LIGHT_DIRECT_QUEUE_ID);
        queue_id = choose_u32(evaluation.valid, queue_id, NULL_QUEUE_ID);
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}