tool
extends MeshInstance

class_name StarNebulaDome

export(float) var star_nebula_seed:float = 0.0 setget set_star_nebula_seed

export(Color) var star_color:Color = Color( 1.0, 1.0, 1.0, 1.0 ) setget set_star_color
export(float) var star_aperture:float = 7.0 setget set_star_aperture

export(Color) var nebula_1_color:Color = Color( 1.0, 0.4, 0.0, 1.0 ) setget set_nebula_1_color
export(float) var nebula_1_aperture:float = 3.0 setget set_nebula_1_aperture
export(float) var nebula_1_power:float = 130.0 setget set_nebula_1_power

export(Color) var nebula_2_color:Color = Color( 0.8, 0.67, 0.0, 1.0 ) setget set_nebula_2_color
export(float) var nebula_2_aperture:float = 3.0 setget set_nebula_2_aperture
export(float) var nebula_2_power:float = 100.0 setget set_nebula_2_power

export(Color) var nebula_3_color:Color = Color( 0.2, 0.2, 1.0, 1.0 ) setget set_nebula_3_color
export(float) var nebula_3_aperture:float = 3.0 setget set_nebula_3_aperture
export(float) var nebula_3_power:float = 90.0 setget set_nebula_3_power

export(bool) var auto_follow_camera:bool = true

func _ready( ):
	self.mesh = CubeMesh.new( )
	self.mesh.flip_faces = true
	self._reset_shader_params( )

func set_star_nebula_seed( _star_nebula_seed:float ):
	star_nebula_seed = _star_nebula_seed
	self._reset_shader_params( )

func set_star_aperture( _star_aperture:float ):
	star_aperture = _star_aperture
	self._reset_shader_params( )

func set_star_color( _star_color:Color ):
	star_color = _star_color
	self._reset_shader_params( )

func set_nebula_1_color( _nebula_1_color:Color ):
	nebula_1_color = _nebula_1_color
	self._reset_shader_params( )

func set_nebula_1_aperture( _nebula_1_aperture:float ):
	nebula_1_aperture = _nebula_1_aperture
	self._reset_shader_params( )

func set_nebula_1_power( _nebula_1_power:float ):
	nebula_1_power = _nebula_1_power
	self._reset_shader_params( )

func set_nebula_2_color( _nebula_2_color:Color ):
	nebula_2_color = _nebula_2_color
	self._reset_shader_params( )

func set_nebula_2_aperture( _nebula_2_aperture:float ):
	nebula_2_aperture = _nebula_2_aperture
	self._reset_shader_params( )

func set_nebula_2_power( _nebula_2_power:float ):
	nebula_2_power = _nebula_2_power
	self._reset_shader_params( )

func set_nebula_3_color( _nebula_3_color:Color ):
	nebula_3_color = _nebula_3_color
	self._reset_shader_params( )

func set_nebula_3_aperture( _nebula_3_aperture:float ):
	nebula_3_aperture = _nebula_3_aperture
	self._reset_shader_params( )

func set_nebula_3_power( _nebula_3_power:float ):
	nebula_3_power = _nebula_3_power
	self._reset_shader_params( )

func _reset_shader_params( ):
	var sns:ShaderMaterial = preload( "StarNebulaMat.tres" ).duplicate( )

	sns.set_shader_param( "seed", self.star_nebula_seed )

	sns.set_shader_param( "star_color", self.star_color )
	sns.set_shader_param( "star_aperture", self.star_aperture )

	sns.set_shader_param( "nebula_1_color", self.nebula_1_color )
	sns.set_shader_param( "nebula_1_aperture", self.nebula_1_aperture )
	sns.set_shader_param( "nebula_1_power", self.nebula_1_power )

	sns.set_shader_param( "nebula_2_color", self.nebula_2_color )
	sns.set_shader_param( "nebula_2_aperture", self.nebula_2_aperture )
	sns.set_shader_param( "nebula_2_power", self.nebula_2_power )

	sns.set_shader_param( "nebula_3_color", self.nebula_3_color )
	sns.set_shader_param( "nebula_3_aperture", self.nebula_3_aperture )
	sns.set_shader_param( "nebula_3_power", self.nebula_3_power )

	self.material_override = sns

func _process( delta:float ):
	self._move_to_camera( )

func _physics_process( delta:float ):
	self._move_to_camera( )

func _move_to_camera( ):
	if not self.auto_follow_camera:
		return

	var camera:Camera = self.get_viewport( ).get_camera( )
	if camera == null:
		return

	var middle:float = ( camera.far + camera.near ) / 2.0
	var middle_size:Vector3 = Vector3.ONE * middle

	self.transform.origin = camera.global_transform.origin
	self.transform.basis.x = Vector3( middle, 0.0, 0.0 )
	self.transform.basis.y = Vector3( 0.0, middle, 0.0 )
	self.transform.basis.z = Vector3( 0.0, 0.0, middle )
