struct Camera {
    u: vec3f,
    v: vec3f,
    w: vec3f,
    origin: vec3f,
    distance: f32,
};

struct Sphere {
    radius: array<f32, SPHERE_COUNT>,
    center_x: array<f32, SPHERE_COUNT>,
    center_y: array<f32, SPHERE_COUNT>,
    center_z: array<f32, SPHERE_COUNT>,
    color_r: array<f32, SPHERE_COUNT>,
    color_g: array<f32, SPHERE_COUNT>,
    color_b: array<f32, SPHERE_COUNT>,
};

struct PathState {
    step_type: array<u32, PATH_COUNT>,
    local_path_index: array<u32, PATH_COUNT>,
    path_length: array<u32, PATH_COUNT>,
    vertex_index: array<u32, PATH_COUNT>,
    ray_origin_x: array<f32, PATH_COUNT>,
    ray_origin_y: array<f32, PATH_COUNT>,
    ray_origin_z: array<f32, PATH_COUNT>,
    ray_direction_x: array<f32, PATH_COUNT>,
    ray_direction_y: array<f32, PATH_COUNT>,
    ray_direction_z: array<f32, PATH_COUNT>,
    scalar_contribution: array<f32, PATH_COUNT>,
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

struct MarkovChain {
    key_hi: array<u32, CHAIN_COUNT>,
    key_lo: array<u32, CHAIN_COUNT>,
    iteration: array<u32, CHAIN_COUNT>,
    numbers_per_iteration: array<u32, CHAIN_COUNT>,
    numbers_per_path: array<u32, CHAIN_COUNT>,
    numbers_per_stream: array<u32, CHAIN_COUNT>,
    large_step_index_hi: array<u32, CHAIN_COUNT>,
    large_step_index_lo: array<u32, CHAIN_COUNT>,
    small_step_count: array<u32, CHAIN_COUNT>,
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
    r: array<atomic<u32>, PIXEL_COUNT>,
    g: array<atomic<u32>, PIXEL_COUNT>,
    b: array<atomic<u32>, PIXEL_COUNT>,
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
    pdf: f32,
    valid: bool,
};