const CAMERA_STREAM_INDEX: u32 = 0;
const LIGHT_STREAM_INDEX: u32 = 1;
const TECHNIQUE_STREAM_INDEX: u32 = 2;

const PI: f32 = 3.14159265358979323846264338327950288;

const NUMBERS_PER_VERTEX: u32 = ${constants.numbersPerVertex};
const MIN_PATH_LENGTH: u32 = 2;
const MAX_PATH_LENGTH: u32 = ${constants.maxPathLength};

const QUEUE_COUNT: u32 = ${constants.queueCount};

const NULL_QUEUE_ID: u32 = 1000;
const SAMPLE_CAMERA_QUEUE_ID: u32 = ${constants.sampleCameraQueueId};
const SAMPLE_LIGHT_QUEUE_ID: u32 = ${constants.sampleLightQueueId};
const INTERSECT_QUEUE_ID: u32 = ${constants.intersectQueueId};
const SAMPLE_MATERIAL_QUEUE_ID: u32 = ${constants.sampleMaterialQueueId};
const CONNECT_QUEUE_ID: u32 = ${constants.connectQueueId};
const CONTRIBUTE_QUEUE_ID: u32 = ${constants.contributeQueueId};

const LIGHT_SPHERE_ID: u32 = ${constants.lightSphereId};

const PATH_COUNT: u32 = ${constants.pathCount};
const SPHERE_COUNT: u32 = ${constants.sphereCount};

const LARGE_STEP_PROBABILITY = 0.3;
const SMALL_STEP_PROBABILITY = 1.0 - LARGE_STEP_PROBABILITY;
const SMALL_STEP: u32 = 0;
const LARGE_STEP: u32 = 1;
const CHAIN_COUNT: u32 = MAX_PATH_LENGTH - MIN_PATH_LENGTH + 1;
const WORKGROUP_SIZE: u32 = ${constants.workgroupSize};

const CAMERA_GROUP: u32 = ${constants.cameraGroup}; 
const CAMERA_BINDING: u32 = ${constants.cameraBinding};
const SPHERE_GROUP: u32 = ${constants.sphereGroup};
const SPHERE_BINDING: u32 = ${constants.sphereBinding};
const CHAIN_GROUP: u32 = ${constants.chainGroup};
const CHAIN_BINDING: u32 = ${constants.chainBinding};
const PATH_STATE_GROUP: u32 = ${constants.pathStateGroup};
const PATH_STATE_BINDING: u32 = ${constants.pathStateBinding};
const IMAGE_GROUP: u32 = ${constants.imageGroup};
const IMAGE_BINDING: u32 = ${constants.imageBinding};
const QUEUES_GROUP: u32 = ${constants.queuesGroup};
const QUEUES_BINDING: u32 = ${constants.queuesBinding}; 
const QUEUE_COUNTS_GROUP: u32 = ${constants.queueCountsGroup};
const QUEUE_COUNTS_BINDING: u32 = ${constants.queueCountsBinding}; 
const DISPATCH_INDIRECT_PARAMETERS_GROUP: u32 = ${constants.dispatchIndirectParametersGroup}; 
const DISPATCH_INDIRECT_PARAMETERS_BINDING: u32 = ${constants.dispatchIndirectParametersBinding};
const UNIFORMS_GROUP: u32 = ${constants.uniformsGroup};
const UNIFORMS_BINDING: u32 = ${constants.uniformsBinding};

const PIXEL_WIDTH: u32 = ${constants.pixelWidth};
const PIXEL_HEIGHT: u32 = ${constants.pixelHeight};
const PIXEL_COUNT: u32 = PIXEL_WIDTH * PIXEL_HEIGHT;

const SIGMA: f32 = 0.01;
const MAX_F32: f32 = 3.40282346638528859812e+38f;

const CAMERA: u32 = 0;
const LIGHT: u32 = 1;

const ULTIMATE: u32 = 0
const PENULTIMATE: u32 = 1;

const HI: u32 = 0;
const LO: u32 = 1;

const PROPOSAL: u32 = 0;
const CURRENT: u32 = 1;

const FIXED_POINT_SCALE: f32 = 1048576.0;