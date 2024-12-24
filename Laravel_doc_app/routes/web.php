<?php

use App\Http\Controllers\DocsController;
use Illuminate\Support\Facades\Route;
use Laravel\Jetstream\Http\Controllers\CurrentUserController;
use Laravel\Jetstream\Http\Controllers\UserApiTokenController;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

Route::get('/', function () {
    return view('welcome');
});

Route::middleware([
    'auth:sanctum',
    config('jetstream.auth_session'),
    'verified'
])->group(function () {
    Route::get('/dashboard', [DocsController::class, 'index'])->name('dashboard');

    // Routes for API Tokens
    Route::get('/user/api-tokens', [UserApiTokenController::class, 'index'])->name('api-tokens.index');
    Route::post('/user/api-tokens', [UserApiTokenController::class, 'store'])->name('api-tokens.store');
    Route::put('/user/api-tokens/{token}', [UserApiTokenController::class, 'update'])->name('api-tokens.update');
    Route::delete('/user/api-tokens/{token}', [UserApiTokenController::class, 'destroy'])->name('api-tokens.destroy');
});
