@fragment
fn fragment_main(input: VertexOutput) -> FragmentOutput {
    let value = read_image(input.position.x, input.position.y);
    let color = gamma_correct(tone_map(value));
    let output: FragmentOutput;
    output.color = color;
    return output;
}