import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as JobShowActionCreators from './action';
import { FavoriteButton } from 'components';
import MdLocationCity from 'react-icons/lib/md/location-city';
import MdLocationOn from 'react-icons/lib/md/location-on';
import {
  Wrapper,
  Heading,
  CompanyWrapper,
  CompanyItem,
  Detail,
  FavoriteButtonWrapper
} from './Styles';
import colors from 'styles/colors';
import { TagList, Title, ErrorMessage } from 'components';

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


  renderTechKeywords() {
    const { techKeywords } = this.props.job;
    if (techKeywords.length === 0) return;

    return <TagList tags={techKeywords.map(techKeyword => techKeyword.name)} />;
  }

  renderFavoriteButton() {
    // const {id, favorited } = this.props.job;
    // if (!favorited) { return }
    return (
      <FavoriteButtonWrapper>
        <FavoriteButton
          size='large'
          jobId={1}
          favorited={true}
          handleSwitchFavoriteStatus={this.handleSwitchFavoriteStatus}
        />
      </FavoriteButtonWrapper>
    );
  }

  render() {

    const { loading, errorMessage, job} = this.props;
    const { jobTitle, company, detail, area } = job;
    if(loading) { return(<div></div>) }

    const iconStyle = {
      color: colors.leadSentenceColor,
      marginRight: 5
    }

    if(errorMessage) return <ErrorMessage>{errorMessage}</ErrorMessage>;

    return(
      <Wrapper>
        <Heading>
          <Title>{jobTitle}</Title>
          <CompanyWrapper>
            <CompanyItem>
              <MdLocationCity style={iconStyle} />
              <span>{company.name}</span>
            </CompanyItem>
            <CompanyItem>
              <MdLocationOn style={iconStyle}  />
              <span>{area}</span>
            </CompanyItem>
          </CompanyWrapper>
          {this.renderTechKeywords()}
          {this.renderFavoriteButton()}
        </Heading>
        <Detail>{detail}</Detail>
      </Wrapper>

    )
  }

}

const propTypes = {
  id: PropTypes.string.isRequired,
  job: PropTypes.object,
  errorMessage: PropTypes.string,
  loading: PropTypes.bool.isRequired
}

JobShowContainer.propTypes = propTypes;


export default connect(mapStateToProps, mapDispatchToProps)(JobShowContainer);
