import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as AuthCallbackActionCreators from './action';

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      AuthCallbackActionCreators,
      dispatch
    )
  }
};


class AuthCallbackContainer extends Component {
  constructor(props){
    super(props);
  }

  componentWillMount() {
    this.props.actions.fetchToken(this.getCode());
  }

  getCode() {
    const searchPath = window.location.search;
    return searchPath.substr(6, searchPath.length);
  }

  render() {
    return(<div />)
  }
}

export default connect(null, mapDispatchToProps)(AuthCallbackContainer);
