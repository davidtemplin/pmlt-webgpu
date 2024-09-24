@compute
@workgroup_size(1)
fn build_pdf() {
    var sum: f32 = 0.0;
    for var i: u32 = 0; i < CHAIN_COUNT; i++ {
        sum += chain.b[i];
    }

    for var i: u32 = 0; i < CHAIN_COUNT; i++ {
        chain.pdf[i] = chain.b[i] / sum;
    }

    // Compute the bounds of each chain
    var sum: f32 = 0.0;
    var min_path_index: u32 = 0;
    for(var i: u32 = 0; i < CHAIN_COUNT; i++) {
        sum += chain.pdf[i];
        let max_path_index = u32(round(sum * f32(PATH_COUNT)));
        chain.min_path_index[i] = min_path_index;
        chain.max_path_index[i] = max_path_index;
        chain.path_count[i] = max_path_index - min_path_index + 1;
        min_path_index += max_path_index;
    }
}