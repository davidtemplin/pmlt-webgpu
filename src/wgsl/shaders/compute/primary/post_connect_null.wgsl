@compute
@workgroup_size(WORKGROUP_SIZE)
fn post_connect_null_main(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[POST_NULL_CONNECT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    let queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue.count[POST_NULL_CONNECT_QUEUE_ID]) {
        // MIS
        let p1 = get_point(CAMERA, PENULTIMATE, i);
        let p2 = get_point(CAMERA, ULTIMATE, i);
        let n1 = get_normal(CAMERA, PENULTIMATE, i);
        let n2 = get_normal(CAMERA, ULTIMATE, i);
        let d1 = p2 - p1;
        let d2 = p1 = p2;

        let ri1 = light_directional_pdf(d2, n2) * direction_to_area(d2, n1) / path.pdf_fwd[CAMERA][PENULTIMATE][i];
        path.prod_ri[CAMERA][i] *= ri1;
        path.sum_inv_ri[CAMERA][i] += 1.0 / ri1;

        let ri2 = light_positional_pdf(p2) / path.pdf_fwd[CAMERA][ULTIMATE][i];
        path.prod_ri[CAMERA][i] *= ri2;
        path.sum_inv_ri[CAMERA][i] += 1.0 / ri2;

        // Next queue
        queue_id = CONTRIBUTE_QUEUE_ID;
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}