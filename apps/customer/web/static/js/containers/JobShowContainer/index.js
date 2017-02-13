import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobShowActionCreators from './action';

const propTypes = {

}

function mapStateToProps({jobShow}) {
  const { job, loading, errorMessage } = jobShow;
  return {
    job,
    loading,
    errorMessage
  }
}

function mapDispatchToProps(dispatch) {
  return {
    actions: bindActionCreators(
      JobShowActionCreators,
      dispatch
    )
  }
}

class JobShowContainer extends Component {

  constructor(props) {
    super(props);
  }

  componentWillMount() {
    this.props.actions.fetchJob(this.props.params.id);
  }

  render() {
    return (
      <div />
    )
  }

}

JobShowContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobShowContainer);
