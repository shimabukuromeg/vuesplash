<?php

// 会員登録
Route::post('/register', 'Auth\RegisterController@register')->name('register');
