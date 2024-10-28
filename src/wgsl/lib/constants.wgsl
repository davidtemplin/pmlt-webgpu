const CAMERA_STREAM_INDEX: u32 = 0;
const LIGHT_STREAM_INDEX: u32 = 1;
const TECHNIQUE_STREAM_INDEX: u32 = 2;

const PI: f32 = 3.14159265358979323846264338327950288;

const NUMBERS_PER_VERTEX: u32 = ${config.random.counts.vertex};
const MIN_PATH_LENGTH: u32 = 2;
const MAX_PATH_LENGTH: u32 = ${config.path.length.max};

const NUMBERS_PER_CHAIN: u32 = ${config.random.counts.path.max};

const QUEUE_COUNT: u32 = ${config.queue.count};

const NULL_QUEUE_ID: u32 = 1000;
const SAMPLE_CAMERA_QUEUE_ID: u32 = ${config.queue.index.sample.camera};
const SAMPLE_LIGHT_QUEUE_ID: u32 = ${config.queue.index.sample.light};
const INTERSECT_QUEUE_ID: u32 = ${config.queue.index.intersect};
const SAMPLE_MATERIAL_QUEUE_ID: u32 = ${config.queue.index.sample.material};
const CONNECT_QUEUE_ID: u32 = ${config.queue.index.connect};
const POST_CONNECT_CAMERA_DIRECT_QUEUE_ID: u32 = ${config.queue.index.postConnect.camera.direct};
const POST_CONNECT_CAMERA_INDIRECT_QUEUE_ID: u32 = ${config.queue.index.postConnect.camera.indirect};
const POST_CONNECT_LIGHT_DIRECT_QUEUE_ID: u32 = ${config.queue.index.postConnect.light.direct};
const POST_CONNECT_LIGHT_INDIRECT_QUEUE_ID: u32 = ${config.queue.index.postConnect.light.indirect};
const POST_CONNECT_NULL_QUEUE_ID: u32 = ${config.queue.index.postConnect.null};
const CONTRIBUTE_QUEUE_ID: u32 = ${config.queue.index.contribute};

const LIGHT_SPHERE_ID: u32 = ${config.sphere.id.light};

const PATH_COUNT: u32 = ${config.path.count};
const SPHERE_COUNT: u32 = ${config.sphere.count};

const LARGE_STEP_PROBABILITY = 0.3;
const SMALL_STEP_PROBABILITY = 1.0 - LARGE_STEP_PROBABILITY;
const SMALL_STEP: u32 = 0;
const LARGE_STEP: u32 = 1;
const NO_STEP: u32 = 2;
const CHAIN_COUNT: u32 = MAX_PATH_LENGTH - MIN_PATH_LENGTH + 1;
const WORKGROUP_SIZE: u32 = ${config.workgroup.size};

const CAMERA_GROUP: u32 = ${config.bindGroup.primary.index}; 
const CAMERA_BINDING: u32 = ${config.bindGroup.primary.binding.camera};
const SPHERE_GROUP: u32 = ${config.bindGroup.primary.index};
const SPHERE_BINDING: u32 = ${config.bindGroup.primary.binding.sphere};
const CHAIN_GROUP: u32 = ${config.bindGroup.primary.index};
const CHAIN_BINDING: u32 = ${config.bindGroup.primary.binding.chain};
const PATH_GROUP: u32 = ${config.bindGroup.primary.index};
const PATH_BINDING: u32 = ${config.bindGroup.primary.binding.path};
const IMAGE_GROUP: u32 = ${config.bindGroup.primary.index};
const IMAGE_BINDING: u32 = ${config.bindGroup.primary.binding.image};
const QUEUE_GROUP: u32 = ${config.bindGroup.primary.index};
const QUEUE_BINDING: u32 = ${config.bindGroup.primary.binding.queue}; 
const PATH_LOG_GROUP: u32 = ${config.bindGroup.primary.index};
const PATH_LOG_BINDING: u32 = ${config.bindGroup.primary.binding.pathLog};
const DISPATCH_INDIRECT_PARAMETERS_GROUP: u32 = ${config.bindGroup.auxiliary.index}; 
const DISPATCH_INDIRECT_PARAMETERS_BINDING: u32 = ${config.bindGroup.auxiliary.binding.dispatchIndirectParameters};
const UNIFORM_GROUP: u32 = ${config.bindGroup.uniform.index};
const UNIFORM_BINDING: u32 = ${config.bindGroup.uniform.binding.parameters};

const PIXEL_WIDTH: u32 = ${config.image.width};
const PIXEL_HEIGHT: u32 = ${config.image.height};
const PIXEL_COUNT: u32 = PIXEL_WIDTH * PIXEL_HEIGHT;

const SIGMA: f32 = 0.01;
const MAX_F32: f32 = 3.40282346638528859812e+38f;
const MIN_F32: f32 = 1.175494e-38f;

const CAMERA: u32 = 0;
const LIGHT: u32 = 1;

const ULTIMATE: u32 = 0;
const PENULTIMATE: u32 = 1;

const HI: u32 = 0;
const LO: u32 = 1;

const PROPOSAL: u32 = 0;
const CURRENT: u32 = 1;

const FIXED_POINT_SCALE: f32 = f32(2 << 16);

const PATH_LOG_TARGET_INDEX: u32 = ${config.pathLog.targetIndex};
const PATH_LOG_ENABLED: bool = ${config.pathLog.enabled};

const PRIMARY: u32 = 0;
const AUXILIARY: u32 = 1;

const DISABLED: u32 = 0;
const ENABLED: u32 = 1;

const MAX_CONTRIBUTION: f32 = 0.5;

const GAMMA: f32 = 2.2;
const TONE_MAPPING_SCALE: f32 = 100.0;
