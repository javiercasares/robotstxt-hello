<?php
/**
 * Main plugin class responsible for registering the Hello admin page.
 *
 * @package Robotstxt_Hello
 */

if ( ! class_exists( 'Robotstxt_Hello_Plugin' ) ) {
	/**
	 * Handles registration of the Hello menu and page.
	 */
	final class Robotstxt_Hello_Plugin {

		/**
		 * Registers WordPress hooks required by the plugin.
		 *
		 * @return void
		 */
		public function register(): void {
			add_action( 'admin_menu', array( $this, 'register_admin_menu' ) );
		}

		/**
		 * Adds the Hello admin menu entry at the bottom of the menu list.
		 *
		 * @return void
		 */
		public function register_admin_menu(): void {
			add_menu_page(
				esc_html__( 'Hello', 'robotstxt-hello' ),
				esc_html__( 'Hello', 'robotstxt-hello' ),
				'manage_options',
				'robotstxt-hello',
				array( $this, 'render_admin_page' ),
				'dashicons-admin-site',
				PHP_INT_MAX
			);
		}

		/**
		 * Renders the Hello admin page content.
		 *
		 * @return void
		 */
		public function render_admin_page(): void {
			echo '<div class="wrap">';
			echo '<h1>' . esc_html__( 'Hello', 'robotstxt-hello' ) . '</h1>';
			echo '</div>';
		}
	}
}
