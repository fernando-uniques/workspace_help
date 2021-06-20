#!/bin/bash
# Example createLaravelAuth.sh newapi

if [ -z "$1" ]
    then echo "Please, specify the project name." 
    exit
fi

projectName=$1

composer create-project --prefer-dist laravel/laravel $projectName

cd $projectName

#php artisan serve

composer require laravel/passport

php artisan migrate

php artisan passport:install

# User.php
# use Laravel\Passport\HasApiTokens; // Add this
# use Notifiable, HasApiTokens; // Edit this line

# AuthServiceProvider.php
# 'App\Model' => 'App\Policies\ModelPolicy', // uncomment this line
# Passport::routes(); // Add this

# config/auth.php
# 'driver' => 'passport', // set this to passport, in api configuration

php artisan make:controller API/AuthController

# routes.api.php
# Route::get('/test', function (Request $request) {
#    return 'test ok';
# });
# Route::post('/register', 'Api\AuthController@register');
# Route::post('/login', 'Api\AuthController@login');
# Route::middleware(['auth:api'])->group(function () {
# });
# Route::fallback(function(){
#     return response()->json([
#         'message' => 'Page Not Found. If error persists, contact info@website.com'
#     ], 404);
# });

sudo chmod 777 -R storage/

# Postman
# URL: http://www.domain.test/public/api
# pm.request.headers.add({key: 'Accept', value: 'application/json' });


# Gateway
# AuthServiceProvider.php
Gate::define('permission', function($user) {
    return $user->id === 1;
});


# Artisan
php artisan make:model Doctor -a
php artisan make:request DoctorStoreRequest
php artisan make:resource DoctorResource
php artisan make:migration create_users_table


# Migration
# Model
# Factory
# Faker
# Controller
# Test
# FormRequest
# Resource
# Event
# Job
# Email


# Migration
$table->string('name', 200);
$table->foreignId('doctor_id')->constrained()->onDelete('cascade');
$table->date('birth_date');
$table->enum('gender', ['MASCULINE', 'FEMININE']);
$table->string('address')->nullable();
$table->string('phone', 15)->nullable();
$table->string('specialiby')->nullable();
$table->enum('language', ['ENGLISH', 'PORTUGUESE', 'FRENCH']);
$table->softDeletes();
$table->timestamps();
$table->index('doctor_id');


# Model
public const GENDERS = ['MASCULINE', 'FEMININE', 'OTHER'];
use SoftDeletes;
protected $fillable = [];
protected $guarded = [];
protected $with = [];
protected $appends = [];
protected $touches = [];
protected $hidden = [];
protected $casts = [];
protected $perPage = 20;

# Factory
'name' => $faker->unique()->name,
'name' => $faker->title,
'birth_date' => $faker->date(),
'gender' => $faker->randomElement(Doctor::GENDERS),
'address' => $faker->address,
'phone' => $faker->phoneNumber,
'speciality' => $faker->text(200),
'notes' => $faker->paragraph,
'price' => $faker->randomFloat(2);
'number' => $faker->randomNumber(4)
'languages' => implode(',',$faker->randomElements(Doctor::LANGUAGES, rand(1,3)))

# Seed
factory(Doctor::class, 10)->create();

Plan::inRandomOrder()->first();

factory(Plan::class, 10)->create()->each(function ($plan) {
    for ($i=0; $i<rand(1,3); $i++) {
        $plan->items()->save(
            factory(PlanItem::class)->make(['plan_id'=>$plan->id])
        );
    }
});



# Controller

public function index()
{
    return response([
        Doctor::paginate()
    ]);
}
public function index()
{
    return response([
        'list' => Doctor::all()
    ]);
}

public function store(DoctorStoreRequest $request)
{
    // $validatedData = $request->validate([
    //     'name' => 'required|max:200|unique:doctors',
    //     'birth_date' => 'required|date',
    //     'gender' => sprintf('required|in:%s',implode(',', Doctor::GENDERS)),
    //     'address' => '','phone' => '',
    //     'speciality' => '',
    //     'languages' => '',
    // ]);
    $validatedData = $request->validated();
    $doctor = Doctor::create($validatedData);
    return response([
        'message' => 'Successfully stored.',
        'data' => $doctor
    ]);
}

public function show(Doctor $doctor)
{
    return response([
        'data' => $doctor
    ]);
}

public function update(Request $request, Doctor $doctor)
{
    $validatedData = $request->validate([
        'name' => 'required|max:200|unique:doctors,name,'.($doctor->id??'0').',id',
        'birth_date' => 'required|date',
        'gender' => sprintf('required|in:%s',implode(',', Doctor::GENDERS)),
        'address' => '','phone' => '',
        'speciality' => '',
        'languages' => '',
    ]);
    $doctor->fill($validatedData)->save();
    return response([
        'message' => 'Successfully updated.',
        'data' => $doctor
    ]);
}

public function destroy(Doctor $doctor)
{
    $doctor->delete();
    return response([
        'message' => 'Successfully removed.'
    ]);
}

