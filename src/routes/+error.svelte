<script>
	import '../app.css';

	import { page } from '$app/stores';
</script>

<div class="section">
	<div class="container">
		<article class="message is-danger">
			<div class="message-header">
				<p>Error {$page.status}</p>
			</div>
			<div class="message-body">{$page.error.message}</div>
		</article>
	</div>
</div>