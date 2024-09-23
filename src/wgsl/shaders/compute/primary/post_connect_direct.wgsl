@compute
@workgroup_size(WORKGROUP_SIZE)
fn connect(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[POST_CONNECT_DIRECT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    let queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if i < atomicLoad(&queue.count[POST_CONNECT_DIRECT_QUEUE_ID]) {
        // MIS
        let p1 = get_point(CAMERA, ULTIMATE, i);
        let p2 = get_point(LIGHT, ULTIMATE, i);
        let n1 = get_normal(CAMERA, ULTIMATE, i);
        let n2 = get_normal(LIGHT, ULTIMATE, i);
        let d1 = p2 - p1;
        let d2 = p1 = p2;

        let ri1 = light_directional_pdf(d2, n2) * direction_to_area(d2, n1) / path.pdf_fwd[CAMERA][ULTIMATE][i];
        path.prod_ri[CAMERA][i] *= ri1;
        path.sum_inv_ri[CAMERA][i] += 1.0 / ri1;

        let ri2 = camera_directional_pdf(d1) * direction_to_area(d1, n2) / path.pdf_fwd[LIGHT][ULTIMATE][i];
        path.prod_ri[LIGHT][i] *= ri2;
        path.sum_inv_ri[LIGHT][i] += 1.0 / ri2;

        // Next queue
        queue_id = CONTRIBUTE_QUEUE_ID;
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}