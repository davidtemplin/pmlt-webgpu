@compute
@workgroup_size(WORKGROUP_SIZE)
fn post_connect_camera_direct_main(@builtin(global_invocation_id) gid: vec3u, @builtin(local_invocation_index) lid: u32) {
    // Determine the global path index (i)
    let global_invocation_index = gid.x;
    let i = queue.index[POST_CONNECT_CAMERA_DIRECT_QUEUE_ID][global_invocation_index];

    // Default to no queue
    var queue_id: u32 = NULL_QUEUE_ID;

    // Check bounds
    if global_invocation_index < atomicLoad(&queue.count[POST_CONNECT_CAMERA_DIRECT_QUEUE_ID]) {
        // Context
        let technique = get_technique(i);

        // Geometry
        let p1 = get_point(CAMERA, ULTIMATE, i);
        let p2 = get_point(LIGHT, ULTIMATE, i);
        let n1 = get_point(CAMERA, ULTIMATE, i);
        let n2 = get_normal(LIGHT, ULTIMATE, i);
        let d1 = p2 - p1;

        // Beta
        let beta = vec3f(1.0, 1.0, 1.0) * choose_f32(technique.light > 1, geometry_term(d1, n1, n2), 1.0);
        update_beta(i, beta);

        // MIS
        let ri = camera_directional_pdf(d1) * direction_to_area(d1, n2) / path.pdf_fwd[LIGHT][ULTIMATE][i];
        path.prod_ri[LIGHT][i] *= ri;
        path.sum_inv_ri[LIGHT][i] += 1.0 / ri;

        // Pixel coordinates
        let pc = get_point(CAMERA, ULTIMATE, i);
        let pl = get_point(LIGHT, ULTIMATE, i);
        let d = pc - pl;
        let ray = Ray(pl, d);
        let pixel = get_pixel_coordinates(ray);
        set_pixel(i, pixel.x, pixel.y);

        // Next queue
        queue_id = choose_u32(technique.light > 1, POST_CONNECT_LIGHT_INDIRECT_QUEUE_ID, POST_CONNECT_LIGHT_DIRECT_QUEUE_ID);
        queue_id = choose_u32(pixel.valid, queue_id, NULL_QUEUE_ID);
    }

    // Enqueue
    enqueue(i, lid, queue_id);
}