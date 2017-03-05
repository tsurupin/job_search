import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobShowActionCreators from './action';

const propTypes = {
  id: PropTypes.string.isRequired
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
    this.props.actions.fetchJob(this.props.id);
  }

  renderTechKeyword() {
    const { techKeywords } = this.props.job;
    return (
      <ul>
          {techKeywords.map(techKeyword => {
            return <li key={techKeyword.id}><p>{techKeyword.name}</p></li>
        })}
      </ul>
    )
  }

  render() {
      console.log(this.props)
    const { loading, errorMessage, job} = this.props;
    const {jobTitle, company, detail, updatedAt} = job;
    if(loading) { return(<div></div>) }

    return (
      <article>
        <h2>{jobTitle}</h2>
        <h4>{company.name}</h4>
        <span>{updatedAt}</span>
          {this.renderTechKeyword()}
        <p>{detail}</p>

      </article>

    )
  }

}

JobShowContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobShowContainer);
