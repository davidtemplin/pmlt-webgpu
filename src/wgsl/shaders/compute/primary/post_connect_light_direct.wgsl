@compute
@workgroup_size(WORKGROUP_SIZE)
fn post_connect_light_direct_main(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[POST_CONNECT_LIGHT_DIRECT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if global_invocation_index < atomicLoad(&queue.count[POST_CONNECT_LIGHT_DIRECT_QUEUE_ID]) {
        // Geometry
        let p1 = get_point(CAMERA, ULTIMATE, i);
        let p2 = get_point(LIGHT, ULTIMATE, i);
        let n1 = get_normal(CAMERA, ULTIMATE, i);
        let n2 = get_normal(LIGHT, ULTIMATE, i);
        let d1 = p2 - p1;
        let d2 = p1 - p2;

        // Validation
        let valid = light_direction_valid(d2, n2);

        // Beta
        let beta = vec3f(1.0, 1.0, 1.0) * geometry_term(d1, n1, n2);
        update_beta(i, beta);

        // MIS
        let ri = light_directional_pdf(d2, n2) * direction_to_area(d2, n1) / path.pdf_fwd[CAMERA][ULTIMATE][i];
        path.prod_ri[CAMERA][i] *= ri;
        path.sum_inv_ri[CAMERA][i] += 1.0 / path.prod_ri[CAMERA][i];

        path.prod_ri[LIGHT][i] *= path.final_ri[i];
        path.sum_inv_ri[LIGHT][i] += 1.0 / path.prod_ri[LIGHT][i];

        // Next queue
        queue_id = choose_u32(valid, CONTRIBUTE_QUEUE_ID, NULL_QUEUE_ID);
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}