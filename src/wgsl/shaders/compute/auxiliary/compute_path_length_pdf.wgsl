@compute
@workgroup_size(1)
fn compute_path_length_pdf() {
    var sum: f32 = 0.0;
    for var i: u32 = 0; i < CHAIN_COUNT; i++ {
        sum += chain.path_length_pdf[i];
    }
    for var i: u32 = 0; i < CHAIN_COUNT; i++ {
        chain.path_length_pdf[i] = chain.path_length_pdf[i] / sum;
    }
}