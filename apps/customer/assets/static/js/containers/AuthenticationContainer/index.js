import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as AuthenticationActionCreators from './action';

export default function(ComposedComponent) {

  function mapStateToProps({authentication}) {
    const { authenticated } = authentication;
    return {
      authenticated
    }
  }

  function mapDispatchToProps(dispatch) {
    return {
      actions: bindActionCreators(
        AuthenticationActionCreators,
        dispatch
      )
    }
  }
  const propTypes = {
    actions: PropTypes.shape({
      fetchToken: PropTypes.func.isRequired,
      logout: PropTypes.func.isRequired
    }),
    authenticated: PropTypes.bool.isRequired
  };

  class AuthenticationContainer extends Component {
    constructor(props) {
      super(props)
    }

    static contextTypes = {
      router: PropTypes.object
    };

    componentDidMount() {
      const token = this.getToken();
      if (token) return this.props.actions.fetchToken(token);
      this.redirectRootOrLogoutIfNecessary(this.props.authenticated);
    }

    componentWillUpdate({ authenticated }) {
      this.redirectRootOrLogoutIfNecessary(authenticated);
    }

    getToken() {
      return window.document.getElementById('token').textContent;
    }


    redirectRootOrLogoutIfNecessary(authenticated) {
      if (!authenticated) return this.context.router.push('/');

      if (typeof localStorage.getItem('token') === 'undefined') {
        this.props.actions.logout()
      }
    }

    render() {
      return <ComposedComponent {...this.props} />
    }
  }

  AuthenticationContainer.propTypes = propTypes;
  return connect(mapStateToProps, mapDispatchToProps)(AuthenticationContainer)
}
