<!-- resources/views/components/jet-checkbox.blade.php -->

<label {{ $attributes->merge(['class' => 'flex items-center']) }}>
    <input type="checkbox" class="form-checkbox" {{ $attributes }}>
    <span class="ml-2">
        {{ $slot }}
    </span>
</label>
