@group(CAMERA_GROUP) @binding(CAMERA_BINDING) var<storage, read> camera: Camera;
@group(SPHERE_GROUP) @binding(SPHERE_BINDING) var<storage, read> sphere: Sphere;
@group(CHAIN_GROUP) @binding(CHAIN_BINDING) var<storage, read_write> chain: Chain;
@group(PATH_GROUP) @binding(PATH_BINDING) var<storage, read_write> path: Path;
@group(IMAGE_GROUP) @binding(IMAGE_BINDING) var<storage, read_write> image: Image;
@group(QUEUE_GROUP) @binding(QUEUE_BINDING) var<storage, read_write> queue: Queue;
@group(DISPATCH_INDIRECT_PARAMETERS_GROUP) @binding(DISPATCH_INDIRECT_PARAMETERS_BINDING) var<storage, read_write> dispatch_indirect_parameters: array<vec3u, QUEUE_COUNT>;

var<workgroup> workgroup_queue_ballot: array<u32, WORKGROUP_SIZE>;
var<workgroup> workgroup_global_path_index: array<u32, WORKGROUP_SIZE>;

@group(PATH_LOG_GROUP) @binding(PATH_LOG_BINDING) var<storage, read_write> path_log: PathLog;