include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map",
  tracking_frame = "imu_link",
  published_frame = "base_link",
  odom_frame = "odom",
  provide_odom_frame = true,
  publish_frame_projected_to_2d = false,
  use_odometry = false,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 0,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1.,
  fixed_frame_pose_sampling_ratio = 1.,
  imu_sampling_ratio = 1.,
  landmarks_sampling_ratio = 1.,
}


------------------------------------------------------------------------------------------------
--LOCAL SLAM SETTING
------------------------------------------------------------------------------------------------

--Map Builder settings
MAP_BUILDER.use_trajectory_builder_3d = true
MAP_BUILDER.num_background_threads = 7

--TRAJECTORY BUILDER 3D MAIN SETTING
TRAJECTORY_BUILDER_3D.min_range = 4.8
TRAJECTORY_BUILDER_3D.max_range = 100
TRAJECTORY_BUILDER_3D.num_accumulated_range_data = 1
TRAJECTORY_BUILDER_3D.voxel_filter_size = 0.15
--TRAJECTORY_BUILDER_3D.imu_gravity_time_constant = 9.81
--TRAJECTORY_BUILDER_3D.num_odometry_states = 1

TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter.max_length = 5.
TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter.min_num_points = 250.
TRAJECTORY_BUILDER_3D.low_resolution_adaptive_voxel_filter.max_length = 8.
TRAJECTORY_BUILDER_3D.low_resolution_adaptive_voxel_filter.min_num_points = 400.

--Motion filter settings
--TRAJECTORY_BUILDER_3D.motion_filter.max_time_seconds = 0.5
--TRAJECTORY_BUILDER_3D.motion_filter.max_distance_meters = 0.1
--TRAFECTORY_BUILDER_3D.motion_filter.angle_radians = 0.004

--ONLINE CORRELATIVE SCAN MATCHING SETTING
TRAJECTORY_BUILDER_3D.use_online_correlative_scan_matching = true
--TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.linear_search_window = 0.15
--TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.angular_search_window = 0.610865238 --1deg=0.01745329
--TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.translation_delta_cost_weight = 0.1
--TRAJECTORY_BUILDER_3D.real_time_correlative_scan_matcher.rotation_delta_cost_weight = 0.1

--CERES SCAN MATCHER SETTINGS
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.translation_weight = 10 --Cost of translating a new scan from the submap.
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.rotation_weight = 4 --Cost of rotating a new scan from the submap. Default=4e2, reccommended=2e1
--TRAJECTORY_BUILDER_3D.ceres_scan_matcher.occupied_space_weight_0 = 1.0
--TRAJECTORY_BUILDER_3D.ceres_scan_matcher.occupied_space_weight_1 = 6.0
--TRAJECTORY_BUILDER_3D.ceres_scan_matcher.only_optimize_yaw = false
--TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.use_nomonotonic_steps = false
TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.max_num_iterations = 40
--TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.num_threads = 1

--TRAJECTORY BUILDER SUBMAP SETTING
TRAJECTORY_BUILDER_3D.submaps.high_resolution = 0.25
TRAJECTORY_BUILDER_3D.submaps.high_resolution_max_range = 20
TRAJECTORY_BUILDER_3D.submaps.low_resolution = 0.45
TRAJECTORY_BUILDER_3D.submaps.num_range_data = 80   --Efectively the 'size' of each submap.
TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.hit_probability = 0.55
TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.miss_probability = 0.49
TRAJECTORY_BUILDER_3D.submaps.range_data_inserter.num_free_space_voxels = 2


-----------------------------------------------------------------------------------------------
--GLOBAL SLAM SETTING
-----------------------------------------------------------------------------------------------

--Global Slam Basic Setting
POSE_GRAPH.optimize_every_n_nodes = 100
POSE_GRAPH.matcher_rotation_weight = 1.6e3
POSE_GRAPH.matcher_translation_weight = 5e2
--POSE_GRAPH.max_num_final_iterations = 200
POSE_GRAPH.global_sampling_ratio = 0.001 

--MAP_BUILDER.pose_graph.constraint_builder.adaptive_voxel_filter = TRAJECTORY_BUILDER_3D.high_resolution_adaptive_voxel_filter

--Global SLAM constraint builder options
POSE_GRAPH.constraint_builder.min_score = 0.5
POSE_GRAPH.constraint_builder.sampling_ratio = 0.005
POSE_GRAPH.constraint_builder.global_localization_min_score = 0.7
POSE_GRAPH.constraint_builder.loop_closure_translation_weight = 1e4
POSE_GRAPH.constraint_builder.loop_closure_rotation_weight = 1e5
POSE_GRAPH.constraint_builder.log_matches = true
POSE_GRAPH.constraint_builder.max_constraint_distance= 100.

--Global SLAM optimization settings
POSE_GRAPH.optimization_problem.huber_scale = 3e2
POSE_GRAPH.optimization_problem.acceleration_weight = 750
POSE_GRAPH.optimization_problem.rotation_weight = 140
POSE_GRAPH.optimization_problem.log_solver_summary = false
POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 200
--POSE_GRAPH.optimization_problem.ceres_solver_options.num_threads = 1

--GLOBAL SLAM CERES SCAN Matcher
--POSE_GRAPH.constraint_builder.ceres_scan_matcher.occupied_space_weight = 20
POSE_GRAPH.constraint_builder.ceres_scan_matcher.translation_weight = 10
POSE_GRAPH.constraint_builder.ceres_scan_matcher.rotation_weight = 3
POSE_GRAPH.constraint_builder.ceres_scan_matcher.ceres_solver_options.max_num_iterations = 50
--POSE_GRAPH.constraint_builder.ceres_scan_matcher.ceres_solver_options.use_nonmonotonic_steps = true
--POSE_GRAPH.constraint_builder.ceres_scan_matcher.ceres_solver_options.num_threads = 7

--Global SLAM Ceres 3D scan matcher
--POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.occupied_space_weight_0 = 5.0
--POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.occupied_space_weight_1 = 30.0
POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.translation_weight = 10.0
POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.rotation_weight = 1.0
POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.only_optimize_yaw = false
POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.use_nonmonotonic_steps = false
POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.max_num_iterations = 50
POSE_GRAPH.constraint_builder.ceres_scan_matcher_3d.ceres_solver_options.num_threads = 1

--fast correlative scan matcher
--POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.branch_and_bound_depth = 8
--POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.full_resolution_depth = 3
POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.min_rotational_score = 0.77
POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_xy_search_window = 30.
POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.linear_z_search_window = 10.
POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher_3d.angular_search_window = math.rad(60.)

POSE_GRAPH.global_constraint_search_after_n_seconds = 25.

return options
