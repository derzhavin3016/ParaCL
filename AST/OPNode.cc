//
// Created by andrey on 21.02.2021.
//

#include "OPNode.hh"

/////////////////////////PLNode METHODS //////////////////

AST::PLNode::PLNode(INode *left, INode *right) : OPNode(left, right)
{
}

/**
 * Calculate value of node function
 * @return
 */
int AST::PLNode::calc() const
{
  return left_->calc() + right_->calc();
}

//////////////////END OF PLNode METHODS //////////////////

/////////////////////////SBNode METHODS //////////////////

AST::SBNode::SBNode(INode *left, INode *right) : OPNode(left, right)
{
}

/**
 * Calculate value of node function
 * @return
 */
int AST::SBNode::calc() const
{
  return left_->calc() - right_->calc();
}

//////////////////END OF SBNode METHODS //////////////////

/////////////////////////MLNode METHODS //////////////////

AST::MLNode::MLNode(INode *left, INode *right) : OPNode(left, right)
{
}

/**
 * Calculate value of node function
 * @return
 */
int AST::MLNode::calc() const
{
  return left_->calc() * right_->calc();
}

//////////////////END OF MLNode METHODS //////////////////

/////////////////////////DVNode METHODS //////////////////

AST::DVNode::DVNode(INode *left, INode *right) : OPNode(left, right)
{
}

/**
 * Calculate value of node function
 * @return calculation result
 */
int AST::DVNode::calc() const
{
  return left_->calc() / right_->calc();
}

//////////////////END OF PLNode METHODS //////////////////

////////////////////ASNode METHODS///////////////////////
AST::ASNode::ASNode(VNode *dst, INode *expr) : dst_(dst), expr_(expr)
{
}

/**
 * @brief Interpret the node function
 */
int AST::ASNode::calc() const
{
  int expr_res = expr_->calc();

  dst_->set_val(expr_res);

  return expr_res;
}

/**
 * @brief Assignment class destructor
 */
AST::ASNode::~ASNode()
{
  delete dst_;
  delete expr_;
}
////////////////END OF ASNode METHODS///////////////////
//////////////////////EQNode////////////////////////////

int AST::EQNode::calc() const
{
  return left->calc() == right->calc();
}
///////////////END OF EQNode////////////////////////////



int AST::NEQNode::calc() const
{
  return left->calc() != right->calc();
}

int AST::GNode::calc() const
{
  return left->calc() > right->calc();
}

int AST::GENode::calc() const
{
  return left->calc() >= right->calc();
}
int AST::LNode::calc() const
{
  return left->calc() < right->calc();
}
int AST::LENode::calc() const
{
  return left->calc() <= right->calc();
}
int AST::ANDNode::calc() const
{
  return left->calc() && right->calc();
}
int AST::ORNode::calc() const
{
  return left->calc() || right->calc();
}




















