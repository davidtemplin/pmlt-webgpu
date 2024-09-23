@compute
@workgroup_size(WORKGROUP_SIZE)
fn contribute_main(@builtin(global_invocation_id) id: vec3u) {
    // TODO: also calculate final MIS weight and scalar contribution (via luminance)
    let global_invocation_index = id.x;
    if global_invocation_index < atomicLoad(&queue_counts[CONTRIBUTE_QUEUE_ID]) {
        let global_path_index = queues[CONTRIBUTE_QUEUE_ID][global_invocation_index];
        let path_length = path_state.path_length[global_path_index];
        let chain_id = path_length - MIN_PATH_LENGTH;
        let path_length_pdf = chain.path_length_pdf[chain_id];
        let step_type = path_state.step_type[global_path_index];
        let step_term = f32(step_type == LARGE_STEP);
        let sc = path_state.scalar_contribution[global_path_index];
        let path_count = chain.path_count[chain_id];
        let a = min(1.0, sc / chain.scalar_contribution[chain_id]) / path_count;
        let b = chain.b[chain_id];
        let weight = ((f32(path_length) / path_length_pdf) * (a + step_term)) / ((sc / b) + LARGE_STEP_PROBABILITY);
        let c = path_state.contribution[global_path_index];
        let x = path_state.pixel_coordinates_x[global_path_index];
        let y = path_state.pixel_coordinates_y[global_path_index];
        contribute(c * weight, x, y);
    }
}