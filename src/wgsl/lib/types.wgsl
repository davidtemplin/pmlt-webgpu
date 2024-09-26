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
    cdf: array<f32, PATH_COUNT>,

    /* geometry */
    point: array<array<array<array<f32, PATH_COUNT>, 3>, 3>, 2>,
    normal: array<array<array<array<f32, PATH_COUNT>, 3>, 2>, 2>,

    /* material */
    material_id: array<array<f32, PATH_COUNT>, 2>,

    /* MIS */
    pdf_fwd: array<array<array<f32, PATH_COUNT>, 2>, 2>,
    sum_inv_ri: array<array<f32, PATH_COUNT>, 2>,
    prod_ri: array<array<f32, PATH_COUNT>, 2>,
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
    key_hi: array<u32, CHAIN_COUNT>,
    key_lo: array<u32, CHAIN_COUNT>,
    iteration: array<u32, CHAIN_COUNT>,
    numbers_per_iteration: array<u32, CHAIN_COUNT>,
    numbers_per_path: array<u32, CHAIN_COUNT>,
    numbers_per_stream: array<u32, CHAIN_COUNT>,
    large_step_index_hi: array<u32, CHAIN_COUNT>,
    large_step_index_lo: array<u32, CHAIN_COUNT>,
    small_step_count: array<u32, CHAIN_COUNT>,
    b: array<f32, CHAIN_COUNT>,
    pdf: array<f32, CHAIN_COUNT>,
    min_small_step_index: array<u32, CHAIN_COUNT>,
    max_small_step_index: array<u32, CHAIN_COUNT>,
};

struct RandomParameters {
  step_type: u32,
  local_path_index: u32,
  numbers_per_path: u32,
  stream_index: u32,
  numbers_per_stream: u32,
  vertex_index: u32,
  iteration: u32,
  numbers_per_iteration: u32,
  large_step_index: U64,
  key: U64,
  small_step_count: u32,
};

struct Image {
    pixels: array<array<array<atomic<u32>, PIXEL_WIDTH>, PIXEL_HEIGHT>, 3>,
};

struct InitializeUniforms {
    path_length: u32,
};

struct ClearQueueUniforms {
    queue_id: u32,
}

struct BuildCdfUniforms {
    min_path_index: u32,
    path_count: u32,
    iteration: u32,
};

struct StartChainUniforms {
    chain_id: u32,
    random: f32,
};

struct UpdateChainUniforms {
    chain_id: u32,
    random: f32,
};

struct Intersection {
    point: vec3f,
    normal: vec3f,
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
    throughput: f32,
    valid: bool,
};