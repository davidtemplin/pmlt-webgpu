@group(CAMERA_GROUP) @binding(CAMERA_BINDING) var<storage, read> camera: Camera;
@group(SPHERE_GROUP) @binding(SPHERE_BINDING) var<storage, read> sphere: Sphere;
@group(CHAIN_GROUP) @binding(CHAIN_BINDING) var<storage, read_write> chain: Chain;
@group(PATH_STATE_GROUP) @binding(PATH_STATE_BINDING) var<storage, read_write> path: Path;
@group(IMAGE_GROUP) @binding(IMAGE_BINDING) var<storage, read_write> image: Image;
@group(QUEUES_GROUP) @binding(QUEUES_BINDING) var<storage, read_write> queues: array<array<u32, PATH_COUNT>, QUEUE_COUNT>;
@group(QUEUE_COUNTS_GROUP) @binding(QUEUE_COUNTS_BINDING) var<storage, read_write> queue_counts: array<atomic<u32>, QUEUE_COUNT>;
@group(DISPATCH_INDIRECT_PARAMETERS_GROUP) @binding(DISPATCH_INDIRECT_PARAMETERS_BINDING) var<storage, read_write> dispatch_indirect_parameters: array<vec3u, QUEUE_COUNT>;

var<workgroup> workgroup_queue_ballot: array<u32, WORKGROUP_SIZE>;