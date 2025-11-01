<?php
/**
 * Main plugin class responsible for registering the Hello admin page.
 *
 * @package Robotstxt_Hello
 */

if ( ! class_exists( 'Robotstxt_Hello_Plugin' ) ) {
	/**
	 * Handles registration of the Hello menu and page.
	 *
	 * @since 1.0.0
	 */
	final class Robotstxt_Hello_Plugin {

		/**
		 * Stores the menu slug used when registering the admin page.
		 *
		 * @since 1.0.4
		 *
		 * @var string
		 */
		const MENU_SLUG = 'robotstxt-hello';

		/**
		 * Registers WordPress hooks required by the plugin.
		 *
		 * @since 1.0.0
		 *
		 * @return void
		 */
		public function register() {
			add_action( 'init', array( $this, 'load_textdomain' ) );
			add_action( 'admin_menu', array( $this, 'register_admin_menu' ) );
		}

		/**
		 * Loads the plugin text domain to make translations available.
		 *
		 * @since 1.0.4
		 *
		 * @return void
		 */
		public function load_textdomain() {
			load_plugin_textdomain( 'robotstxt-hello', false, dirname( plugin_basename( __DIR__ ) ) . '/languages/' );
		}

		/**
		 * Adds the Hello admin menu entry at the bottom of the menu list.
		 *
		 * @since 1.0.0
		 *
		 * @return void
		 */
		public function register_admin_menu() {
			add_menu_page(
				esc_html__( 'Hello', 'robotstxt-hello' ),
				esc_html__( 'Hello', 'robotstxt-hello' ),
				'manage_options',
				self::MENU_SLUG,
				array( $this, 'render_admin_page' ),
				'dashicons-admin-site',
				PHP_INT_MAX
			);
		}

		/**
		 * Renders the Hello admin page content.
		 *
		 * @since 1.0.0
		 *
		 * @return void
		 */
		public function render_admin_page() {
			echo '<div class="wrap">';
			echo '<h1>' . esc_html__( 'Hello', 'robotstxt-hello' ) . '</h1>';
			echo '</div>';
		}
	}
}
