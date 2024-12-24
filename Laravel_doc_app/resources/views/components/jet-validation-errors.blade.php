<!-- resources/views/components/jet-validation-errors.blade.php -->

@if ($errors->any())
    <div {{ $attributes->merge(['class' => 'bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative']) }}>
        <strong class="font-bold">Whoops!</strong>
        <span class="block sm:inline">{{ __('There were some problems with your input.') }}</span>
        <ul class="list-disc list-inside mt-2">
            @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
            @endforeach
        </ul>
    </div>
@endif
