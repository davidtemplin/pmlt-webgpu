struct Camera {
    u: vec3f,
    v: vec3f,
    w: vec3f,
    origin: vec3f,
    distance: f32,
};

struct Sphere {
    radius: array<f32, SPHERE_COUNT>,
    center: array<array<f32, SPHERE_COUNT>, 3>,
    color: array<array<f32, SPHERE_COUNT>, 3>,
};

struct Path {
    /* path context */
    step_type: array<u32, PATH_COUNT>,
    index: array<u32, PATH_COUNT>,
    length: array<u32, PATH_COUNT>,
    vertex_index: array<u32, PATH_COUNT>,
    technique: array<array<u32, PATH_COUNT>, 2>,

    /* ray */
    ray_origin: array<array<f32, PATH_COUNT>, 3>,
    ray_direction: array<array<f32, PATH_COUNT>, 3>,

    /* beta */
    beta: array<array<f32, PATH_COUNT>, 3>,

    /* pixel */
    pixel: array<array<u32, PATH_COUNT>, 2>,

    /* CDF */
    cdf: array<array<f32, PATH_COUNT>, 2>,

    /* geometry */
    point: array<array<array<array<f32, PATH_COUNT>, 3>, 2>, 2>,
    normal: array<array<array<array<f32, PATH_COUNT>, 3>, 2>, 2>,

    /* material */
    material_id: array<array<u32, PATH_COUNT>, 2>,

    /* MIS */
    pdf_fwd: array<array<array<f32, PATH_COUNT>, 2>, 2>,
    sum_inv_ri: array<array<f32, PATH_COUNT>, 2>,
    prod_ri: array<array<f32, PATH_COUNT>, 2>,

    /* PDF */
    directional_pdf: array<f32, PATH_COUNT>,

    final_ri: array<f32, PATH_COUNT>,
};

struct U64 {
  hi: u32,
  lo: u32,
};

struct Technique {
    camera: u32,
    light: u32,
};

struct Basis {
    u: vec3f,
    v: vec3f,
    w: vec3f,
};

struct Chain {
    key: array<array<u32, CHAIN_COUNT>, 2>,
    iteration: array<u32, CHAIN_COUNT>,
    numbers_per_iteration: array<u32, CHAIN_COUNT>,
    numbers_per_path: array<u32, CHAIN_COUNT>,
    numbers_per_stream: array<u32, CHAIN_COUNT>,
    b: array<f32, CHAIN_COUNT>,
    pdf: array<f32, CHAIN_COUNT>,
    min_small_step_index: array<u32, CHAIN_COUNT>,
    max_small_step_index: array<u32, CHAIN_COUNT>,
    contribution: array<array<f32, CHAIN_COUNT>, 3>,
    scalar_contribution: array<f32, CHAIN_COUNT>,
    min_path_index: array<u32, CHAIN_COUNT>,
    max_path_index: array<u32, CHAIN_COUNT>,
    path_count: array<u32, CHAIN_COUNT>,
    offset: array<u32, CHAIN_COUNT>,
    pixel: array<array<u32, CHAIN_COUNT>, 2>,
    numbers: array<array<f32, CHAIN_COUNT>, NUMBERS_PER_CHAIN>,
};

struct Image {
    pixels: array<array<array<atomic<u32>, PIXEL_HEIGHT>, PIXEL_WIDTH>, 3>,
    write_mode: u32,
    sample_count: u32,
};

struct Queue {
    index: array<array<u32, PATH_COUNT>, QUEUE_COUNT>,
    count: array<atomic<u32>, QUEUE_COUNT>,
};

struct InitializeUniforms {
    path_length: u32,
};

struct ClearQueueUniforms {
    queue_id: u32,
}

struct BuildCdfUniforms {
    chain_id: u32,
    iteration: u32,
    final_iteration: u32,
};

struct StartChainUniforms {
    chain_id: u32,
    random: f32,
};

struct UpdateChainUniforms {
    chain_id: u32,
    random: f32,
};

struct RestartUniforms {
    chain_id: u32,
};

struct Intersection {
    point: vec3f,
    normal: vec3f,
    sphere_id: u32,
    valid: bool,
};

struct Ray {
    origin: vec3f,
    direction: vec3f,
};

struct PixelCoordinates {
    x: u32,
    y: u32,
    valid: bool,
};

struct MaterialSample {
    wi: vec3f,
    pdf_fwd: f32,
    pdf_rev: f32,
    throughput: vec3f,
    valid: bool,
};

struct CameraSample {
    point: vec3f,
    direction: vec3f,
    normal: vec3f,
    positional_pdf: f32,
    directional_pdf: f32,
    x: u32,
    y: u32,
};

struct LightSample {
    point: vec3f,
    direction: vec3f,
    normal: vec3f,
    positional_pdf: f32,
    directional_pdf: f32,
};

struct MaterialEvaluation {
    pdf_fwd: f32,
    pdf_rev: f32,
    throughput: vec3f,
    valid: bool,
};

struct VertexLog {
    point: vec3f,
    normal: vec3f,
    direction: vec3f,
    sphere_id: u32,
};

struct PathLog {
    vertices: array<VertexLog, MAX_PATH_LENGTH>,
    beta: vec3f,
    mis_weight: f32,
    foo: f32,
};

struct VertexInput {
    @builtin(vertex_index) vertex_index: u32,
};

struct VertexOutput {
    @builtin(position) position: vec4f,
};

struct FragmentOutput {
    @location(0) color: vec4f,
};