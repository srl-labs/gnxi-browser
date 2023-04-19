<script lang="ts">
	import '../app.css';

	import { page } from '$app/stores';
</script>

<div class="p-7 font-nunito">
	<div class="grid place-items-center content-center">
		<article class="rounded min-w-[400px]">
			<div class="text-white bg-red-400 px-5 py-3 rounded-t">
				<p>Error {$page.status}</p>
			</div>
			<div class="bg-red-50 p-5 rounded-b text-red-500">{$page.error.message}</div>
		</article>
	</div>
</div>