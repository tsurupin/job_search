import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobShowActionCreators from './action';
import { FavoriteButton } from 'components';

const propTypes = {
  id: PropTypes.string.isRequired,
  job: PropTypes.object,
  errorMessage: PropTypes.string,
  loading: PropTypes.bool.isRequired
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

    this.handleSwitchFavoriteStatus = this.handleSwitchFavoriteStatus.bind(this);
  }

  componentWillMount() {
    this.props.actions.fetchJob(this.props.id);
  }

  handleSwitchFavoriteStatus(jobId, favorited) {
    if (favorited) {
      this.props.actions.favoriteJob(jobId, favorited)
    } else {
      this.props.actions.unfavoriteJob(jobId, favorited)
    }
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

  renderFavoriteButton() {
    const {id, favorited } = this.props.job;
    if (favorited === undefined) { return }
    return (
      <FavoriteButton
        jobId={id}
        favorited={favorited}
        handleSwitchFavoriteStatus={this.handleSwitchFavoriteStatus}
      />
    );
  }

  render() {

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
        {this.renderFavoriteButton()}
      </article>

    )
  }

}

JobShowContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobShowContainer);
