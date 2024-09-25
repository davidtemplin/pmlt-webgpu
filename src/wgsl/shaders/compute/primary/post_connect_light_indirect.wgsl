@compute
@workgroup_size(WORKGROUP_SIZE)
fn post_connect_light_indirect_main(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_id = id.x;
    let i = queue.index[POST_CONNECT_LIGHT_QUEUE_ID];

    // Default to no queue
    let queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue.count[POST_CONNECT_LIGHT_QUEUE_ID]) {
        // Context
        let material_id = path.material_id[LIGHT][i];

        // Compute geometry
        let p1 = get_point(CAMERA, ULTIMATE, i);
        let p2 = get_point(LIGHT, ULTIMATE, i);
        let p3 = get_point(LIGHT, PENULTIMATE, i);
        let n1 = get_normal(CAMERA, ULTIMATE, i);
        let n2 = get_normal(CAMERA, ULTIMATE, i);
        let n3 = get_normal(LIGHT, PENULTIMATE, i);
        let wo = p3 - p2;
        let wi = p1 - p2;

        // Evaluate material
        let evaluation = evaluate_material(material_id, wo, n2, wi);

        // Beta
        let beta = evaluation.throughput;
        update_beta(i, beta);

        // MIS
        let ri1 = evaluation.pdf_fwd * direction_to_area(wi, n1) / path.pdf_fwd[CAMERA][ULTIMATE][i];
        path.prod_ri[CAMERA][i] *= ri1;
        path.sum_inv_ri[CAMERA][i] += 1.0 / ri1;

        let ri2 = evaluation.pdf_rev * direction_to_area(wo, n3) / path.pdf_fwd[LIGHT][PENULTIMATE][i];
        path.prod_ri[LIGHT][i] *= r12;
        path.sum_inv_ri[LIGHT][i] += 1.0 / ri2;

        // Choose next queue
        queue_id = CONTRIBUTE_QUEUE_ID;
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}